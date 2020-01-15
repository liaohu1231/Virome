#!/usr/bin/python
#coding:utf-8
import os

path=os.path.dirname(os.path.abspath(__file__))
files = os.listdir(path)
file_out=[]
dat_out=open("Hu_virome_fecal_total.fna","w")
study="SRP049645,SRP002430,SRP098739"
studies =study.split(",")

for file in files:
    file_tail= file.split('.')[-1]
    if file_tail == "fa":
        #print(file)
        dat=open(file,"r")
        dat_line=dat.read()
        dat_lines=dat_line.split(">")
        for line in dat_lines:
            name=line.split("|")[0]
            print(name)
            for sra in studies:
                print(sra+" not")
                if sra!=name: ###名字不匹配，写入file_out
                    file_out.append(">"+str(line)+"\n")
for lh in file_out:
    dat_out.write(str(lh))

dat.close()
dat_out.close()
