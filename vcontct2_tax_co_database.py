
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

seq=readfasta("HGVD.database.fna")
f2=open("vcontact2.txt","r")
f3=open("HGVD_vcontact2_database.fasta","w+")
f5=[]

for lines in f2:
	name,tax = lines.split("\t")[:]
	print(name)
	for k,v in seq.items():
		key=k.split(";")[0]
		keynames=key.split(">")[1]
		print(keynames)
		if name == keynames:
			f3.write(str(k)+"-(Vcontact2)"+str(tax)+str(v)+"\n")
			#print(f4)


for lines in f2:
	name = lines.split("\t")[0]
	if name not in f5:
		f5.append(str(name))

for k,v in seq.items():
	key=k.split(";")[0]
	keynames=key.split(">")[1]
	#print(keynames)
	if keynames not in f5:
		unclassified=str(k)+"-(Vcontact2)unclassified contig"+"\n"+str(v)+"\n"
		#unclassified=str(key)
		for line in unclassified:
			if not line in f3:
				#print(line)
				f3.write(str(line))
				#print(f4)


f2.close()
f3.close()
#f3_1.close()