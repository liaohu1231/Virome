#!/usr/bin/python
#coding:utf-8
import os

path=os.path.dirname(os.path.abspath(__file__))
files = os.listdir(path)
file_out=[]
dat_out=open("Hu_virome_fecal_total.fna","w")
study=open("except_sra.txt","r")
studies =study.read()
studies=studies.split("\n")

for file in files:
    file_tail= file.split('.')[-1]
    if file_tail == "fa":
        #print(file)
        dat=open(file,"r")
        dat_line=dat.read()
        dat_lines=dat_line.split(">")
        for sra in studies:
            #print(sra+"_not")
            for line in dat_lines:
                name=line.split("|")[0]
                #print(name)
                if name==sra:
                    print(sra)
                    file_out.append(">"+str(line)+"\n")
                    
for res in file_out:
    dat_out.write(str(res))

dat.close()
dat_out.close()
