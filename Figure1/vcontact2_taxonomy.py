import argparse
import re

parser = argparse.ArgumentParser(description='vcontact2_tax: A taxonomy based on c1.cluster file from vcontact2')
parser.add_argument('-c1',dest="c1",help="input c1.cluster")
parser.add_argument('-ref_ICTV',dest="ICTV",help="input reference_ICTV",default="E:/博士/dezhou/virome/vcontact/reference_ICTV.txt")
args = parser.parse_args()

f1=open(args.c1,"r")
f2=open(args.ICTV,"r")
f4=open("overview_ref.txt","w+")
f3=[]
f6=[]
for line in f2:
	Name,origin,order,family,subfamily,genus=line.split("\t")[:]
	lh=Name+","+order+","+family+","+subfamily+","+genus
	if lh not in f3:
		f3.append(str(lh))


for i in f1:
	VC_n=i.split(",")[0]
	VC=i.split('"')[1:]
	#print(VC)
	for j in VC:
		h=j.split(" ")[:]
		for k in f3:
			m=k.split(",")[0]
			#print(m)
			if m in h:
				res=str(VC_n)+"\t"+str(k)
				res=res.rstrip("\n")
				if res not in f4:
					f4.write(str(res)+"\n")
					f4.flush()

f7=[]
f8=[]
f9=[]


file=open("overview_ref.txt","r")
file=file.readlines()
for line in file:
	line=line.rstrip("\n")
	cluster,name=line.split("\t")[:]
	#print(name)
	species=name.split(",")[0]
	order=name.split(",")[1]
	family=name.split(",")[2]
	genus=name.split(",")[-1]
	sp=cluster+"\t"+order+","+family+","+genus
	if sp not in f7:
		f7.append(str(sp))
for line in file:
	cluster=line.split("\t")[0]
	if cluster not in f8:
		f8.append(str(cluster))

f7=sorted(f7)
family=[]
clus=[]
genus_kong={}

print(f7)
for hang in f7:
	#print(hang)
	cluster,tax=hang.split("\t")[:]
	tax=tax.strip("\n")
	fa=tax.split(',')[1]
	gen=tax.split(',')[2]
	vc_gen=str(cluster)+'\t'+str(gen)
	if cluster not in clus:
		num=0
		clus.append(cluster)
	else:
		num+=1
		print(num)
		print(str(vc_gen))
		classi=str(fa)+','+str(gen)
		genus_kong[cluster]=classi
		if num > 1:
			gen="unclassified"
			classi=str(fa)+','+str(gen)
			genus_kong[cluster]=classi

for i in range(0,len(f8)):
	#print(i)
	row=f8[i]
	#print(row)
	f9.append('\n'+row+"\t")
	for cluster,tax in genus_kong.items():
		#print(tax)
		if cluster == row:
			if tax not in f9:
				f9.append(str(tax)+";")

files=open("vcontact2","w+")
for h in f9:
	print(h)
	if ",,;"+"\n" not in h:
		files.write(str(h))
		files.flush()

f11=open("vcontact2_cluster_member.txt","w+")
f1=open(args.c1,"r")
f1=f1.readlines()

for line in f1:
	#print(line)
	cluster=line.split(",")[0]
	member=line.split('"')[1:]
	for j in member:
		h=j.split(" ")[:]
		for l in h:
			if "~" not in l:
				#print(l)
				if l != "":
					res=str(cluster)+"\t"+str(l)+"\n"
					if "\t"+"\n" not in str(res):
						f11.write(str(res))

f12=open("vcontact2_cluster_member.txt","r")
f13=open("vcontact2","r",encoding='UTF-8')
f14=open("final_vcontact2.tax.txt","w+")
members=[]
f12=f12.readlines()
print(f13)
for row in f13:
	row=row.strip()
	if len(row) > 1:
		print(row)
		cluster,member=row.split("\t")[:]
		member=member.rstrip("\n")
		for hang in f12:
			i=hang.split("\t")[0]
			hang=hang.rstrip("\n")
			#print(i)
			if i == cluster:
				print(i)
				res=str(hang)+"\t"+str(member)+"\t"+"\n"
				if res not in members:
					members.append(str(res))
					f14.write(str(res))
