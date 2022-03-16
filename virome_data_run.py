import subprocess
import re
import os
import time
from collections import Counter

def readfasta(filename):
        fa = open(filename, 'r')
        res = {}
        ID = ''
        for line in fa:
                if line.startswith('>'):
                        ID = line.strip('\n')
                        res[ID] = ''
                else:
                        res[ID] += line.strip('\n')
        return res
#subprocess.call("rm */tmp*.txt",shell=True)
#step1 hmmsearch with VPF database
subprocess.call("bash virome_data.sh")
subprocess.call("bash hmmersearch.sh",shell=True)
#step2 os search files
path=os.path.abspath('.')
print(path)
open_f=[]
for dirpath, dirnames, filenames in os.walk(path):
	#print(dirnames)
	for dir in dirnames:
		try:
			file=os.listdir(str(dir))
			for files in file:
				#print(files)
				file_path=os.path.join(str(dir),str(files))
				houzhui=file_path.split(".")[-1]
				if houzhui=="txt":
					print(file_path)
					open_f.append(str(file_path))
		except FileNotFoundError:
			print("sorry")

file=sys.argv[1] #input hmmersearch outfile  

#for file in open_f:
dir=file.split("/")[0]
print(dir)
with open(file,"r") as hmm:
	hmm_l=hmm.readlines()
	f1=open(str(dir)+"/tmp.txt","w+")
	f2=[]
	for line in hmm_l:
		#print(line)
		if str(line).startswith('#') == False:
			gene=line.split(" ")[0]
			if gene not in f2:
				#print(gene)
				f2.append(str(gene))
	f2.sort()
	for hang in f2:
		f1.write(str(hang)+"\n")
f1.close()

command="for i in $(ls */tmp.txt);do \
j=${i%%/*};for line in $(cat $i);do \
k=${line%_*};echo $k >> $j/tmp2.txt;done;done" 
sub2=subprocess.call(command,shell=True)

#for file in open_f:
dir=file.split("/")[0]
with open(str(dir)+"/hmmout.master","w+") as master:
	tmp=open(str(dir)+"/tmp2.txt","r")
	count=Counter(tmp)
	for k,v in count.items():
		k=k.rstrip("\n")
		master.write(str(k)+"\t"+str(v)+"\n")
p2=subprocess.call("for i in $(ls -d */);do \
if [ ! -f $i/hmmout.filter.master ];then \
cat $i/hmmout.master|awk '$2 > 3' > $i/hmmout.filter.master;\
fi;done",shell=True)
##step2
#for file in open_f:
dir=file.split("/")[0]
with open(str(dir)+"/hmmout.filter.master","r") as name:
	out=open(str(file)+".filter.fna","w+")
	fasta=os.listdir(str(dir))
	for fas in fasta:
		fas_p=os.path.join(str(dir),str(fas))
		houzhui=fas.split(".")[-1]
		if houzhui=="fasta":
			print(fas_p)
			seq=readfasta(str(fas_p))
			name=name.readlines()
			for k,v in seq.items():
				k=k.lstrip(">")
				for names in name:
					contig=names.split("\t")[0]
					if k==contig:
						out.write(">"+str(k)+"\n"+str(v)+"\n")	

#subprocess.call("bash vibrant.sh",shell=True)
'''
subprocess.call("perl Cluster_genomes_5.1.pl -d /public3/home/sc52870/soft/mummer4/bin -f all_phage_combined.fna -c 70 -i 95 -t 5",shell=True)
'''
