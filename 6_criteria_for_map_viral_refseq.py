import os

f1=open("viral_db_evalue.txt","r")
f1=f1.read()
f1=f1.split("\n")
name=[]
sequence=[]

for line in f1:
    line_name=line.split("\t")[0]
    if line_name not in name:
        name.append(line_name)

f2=open("Hu_final.contig.res_3000.fa","r")
f3=open("refseq_viral_aln.fna","w")
f2=f2.read()
f2=f2.split(">")
for seq in f2:
    seq_id=seq.split("\n")[0]
    for names in name:
        if names ==seq_id:
            sequence.append(">"+str(seq))


for lh in sequence:
    f3.write(lh)

f1.close()
f2.close()
f3.close()
