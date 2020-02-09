f1=open("viral_cluster_overview.csv","r")
f2=open("reference_ICTV.txt","r")

f4=open("overview_ref.txt","w+")
f3=[]
f6=[]

for line in f2:
	Name,origin,order,family,genus=line.split(",")[:]
	lh=Name+","+order+","+family+","+genus
	if lh not in f3:
		f3.append(str(lh))

for i in f1:
	VC=i.split('"')[1:]
	#print(VC)
	for j in VC:
		h=j.split(",")[:]
		#print(h)
		for k in f3:
			m=k.split(",")[0]
			#print(m)
			if m in h:
				res=str(j)+"\t"+str(k)
				if res not in f4:
					f4.write(str(res))
					f6.append(str(res))

def mat(filename,out):
	f5=open(out,"w+")
	f6=[]
	f7=[]
	for line in filename:
		name,tax=line.split("\t")[:]
		names=name.split(",")[:]
		print(name)
		for s in names:
			res=str(s)+"\t"+str(tax)
			if res not in f6:
				f6.append(str(res))
	for k in f3:
		m=k.split(",")[0]
		if m not in f7:
			f7.append(str(m))
	for names in f6:
		mem= names.split("\t")[0]
		if mem not in f7:
			f5.write(str(names))
				

mat(f6,"vcontact2.txt")

f1.close()
f2.close()
f4.close()