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
###sorted(d.items(), key=lambda x: x[1]) 中 d.items() 为待排序的对象；
###key=lambda x: x[1] 为对前面的对象中的第二维数据（即value）的值进行排序。
###key=lambda  变量：变量[维数] 。维数可以按照自己的需要进行设置。
seq_len_sort = dict(seq_len_sort)

for k,v in seq_len_sort.items():
	line = str(k)+"\t"+str(v)+"\n"
	if line not in f2:
		f2.write(str(line))

f2.close()