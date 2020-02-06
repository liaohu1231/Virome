import os
import getpass

usr = getpass.getuser()

seq_len = {}
# 把fasta文件全部读取做成字典，键是带‘>’的那一行，值是序列
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
seq = readfasta('dereplicated_total_human_gut_virome_database.fna')

# 做成另外一个字典字典，键是带‘>’的那一行，值是序列长度：
for k,v in seq.items():
    seq_len[k] = len(v)
seq_len_sort = sorted(seq_len.items(), key=lambda x: x[1]) ###lambda函数，返回列表的第二个元素
seq_len_sort = dict(seq_len_sort)

location = {}
lenth_a = 0
lenth_b = 500
bar = 500
# 通过循环的方式找到每个窗口区间内的长度分布，这里选的窗口是500
# 这里的4500是排序之后根据最大值看出来的
while lenth_b < 300000:
    count = 0
    ran = range(lenth_a,lenth_b)
    for k,v in seq_len_sort.items():
        if v in ran:
            count += 1
    location[(str(lenth_a)+ '-'+ str(lenth_b))] = count
    lenth_a += bar
    lenth_b += bar
#print(location)
f = open('t1.txt','w')
f.write('lenth' + '\t' + 'number'+ '\n')
lenth = []
number = []
for k,v in location.items():
    f.write(str(k)+ '\t' + str(v) + '\n')
    lenth.append(k)
    number.append(v)
f.close()
#plt.bar(range(len(lenth)),number)
# 最后matplotlib画图
#xlabels = [x[index] for index in lenth]
#plt.xticks(number, lenth, rotation='vertical')
#plt.show()
