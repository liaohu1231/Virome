import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-i", type=str, help="imput fasta file")
args = parser.parse_args()
file=args.i

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

line=readfasta(file)
f2=open("genome.txt","w+")

for k,v in line.items():
	line[k] = len(v)

seq_len_sort = sorted(line.items(), key=lambda x: x[1]) 
seq_len_sort = dict(seq_len_sort)

for k,v in seq_len_sort.items():
	line = str(k)+"\t"+str(v)+"\n"
	if line not in f2:
		f2.write(str(line))

f2.close()
