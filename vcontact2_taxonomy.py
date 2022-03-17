f1=open("c1.clusters","r")
f2=open("reference_ICTV.txt","r")
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

for i in range(0,len(f8)):
	#print(i)
	row=f8[i]
	#print(row)
	f9.append('\n'+row+"\t")
	for hang in f7:
		#print(hang)
		cluster,tax=hang.split("\t")[:]
		tax=tax.strip("\n")
		#print(tax)
		if cluster == row:
			if tax not in f9:
				f9.append(str(tax)+";")

files=open("vcontact2","w+")
for h in f9:
	if ",,;"+"\n" not in h:
		files.write(str(h))

f11=open("vcontact2_tax.txt","w+")
f1=open("c1.clusters","r")
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

f12=open("vcontact2_tax.txt","r")
f13=open("vcontact2","r")
f14=open("vcontact2.tax.txt","w+")

f12=f12.readlines()
f13=f13.readlines()

for row in f13:
	if row != "\n":
		cluster,member=row.split("\t")[:]
		member=member.rstrip("\n")
		for hang in f12:
			i=hang.split("\t")[0]
			hang=hang.rstrip("\n")
			#print(i)
			if i == cluster:
				print(i)
				res=str(hang)+"\t"+str(member)+"\t"+"\n"
				f14.write(str(res))

f16=open("final.vcantact2.taxa.txt","w+")
f17=open("vcontact2.tax.txt","r")
f17=f17.readlines()


for line in f17:
	contig,cluster,taxa=line.split("\t")[:]
	f16.write("\n"+str(contig)+"\t")
	f17=[]
	unit=taxa.split(";")[0:-1]
	#print(taxa)
	for i in unit:
		order=i.split(",")[0]
		family=i.split(",")[1]
		genus=i.split(",")[2]
		res=str(order)+","+str(family)+","+str(genus)+";"
		print(res) 
		if f17 == []:
			f17.append(str(res))
		if f17 != []:
			f17.append(str(genus)+";")
		for final in f17:
			f16.write(str(final))
