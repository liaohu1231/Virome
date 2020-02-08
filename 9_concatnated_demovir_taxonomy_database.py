
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

seq=readfasta("dereplicated_total_human_gut_virome_database.fna")
f2=open("DemoVir_assignments.txt","r")
f3=open("rename_HGVD.fasta","w+")


for lines in f2:
	name = lines.split("\t")[0]
	order=lines.split("\t")[1]
	family=lines.split("\t")[3]
	for k,v in seq.items():
		key=k.split(".")[0]
		keynames=key.split(">")[1]
		#print(keynames)
		if name == keynames:
			f3.write(str(key)+";"+str(order)+";"+str(family)+"(Demovir)"+"\n"+str(v)+"\n")
			#print(f4)


for lines in f2:
	name = lines.split("\t")[0]
	for k,v in seq.items():
		key=k.split(".")[0]
		keynames=key.split(">")[1]
		#print(keynames)
		if keynames != name:
			unclassified=str(key)+";unclassified contig(Demovir)"+"\n"+str(v)+"\n"
			#unclassified=str(key)
			for line in unclassified:
				if not line in f3:
					#print(line)
					f3.write(str(line))
					#print(f4)




f2.close()
f3.close()
