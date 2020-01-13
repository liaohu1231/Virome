from glob import glob
import os

parent_path=str(os.path.dirname(os.path.abspath(__file__)))
path = os.listdir(parent_path)
print(path)

file_in = open("HuVirDB-1.0.fasta", 'r')  #定义文件file_in，为打开文件result_all_Sequences.fasta
fa_Con = file_in.read()          #.read()是把文件的全部内容读进来
every_fas =  fa_Con.split(">")    #.split(">")是指以>为分隔符把字符串分割为列表，分割后的列表里面不会包含>,即分割后>消失

    ## 写入文件
out_file = open("Hu_final.contig.res.fa", 'w') #  w是可写

for i in every_fas:
    if i != "":
        start = i.index("\n")
        if len(i[start:]) >= 1500:
            out_file.write(">" + i)
out_file.close()
