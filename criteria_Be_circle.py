#!/usr/bin/python
#coding:utf-8
import os

path=os.path.dirname(os.path.abspath(__file__))
files = os.listdir(path)
file_out=[]
dat_out=open("Hu_virome_database.circle","w")

for file in files:
    file_tail= file.split('.')[-1]
    if file_tail == "fa":
        print(file)
        dat=open(file,"r")
        dat_line=dat.read()
        dat_lines=dat_line.split(">")
        for line in dat_lines:
            start=dat_line.index("\n")
            sequence=line[start:]
            length=len(line[start:])
            length=length-20
            #print(sequence)
            for i in range(0,length):
                j=i+20
                forward=sequence[i:j]
                reverse=sequence[-20:]
                #print(forward)
                if forward==reverse:
                    #print(line)
                    file_out.append(">"+str(line)+"\n")
                    print(file_out)


for res in file_out:
    dat_out.write(str(res))

dat_out.close()
dat.close()
