#!/usr/bin/env python
import os
import subprocess
subprocess.call(['','',])
f1=open("evalue.txt","r")
f1=f1.read()
f1=f1.split("\n")
name=[]
sequence=[]

for line in f1:
    line_name=line.split("\t")[0]
    if line_name not in name:
        name.append(line_name)

f2=open("Hu_final.contig.res_3000.fa","r")
f3=open("refseq_bacteria_not_aln.fna","w")
f2=f2.read()
f2=f2.split(">")
print(name)

for seq in f2:
    seq_id=seq.split("\n")[0]
    if seq_id not in name:
        sequence.append(">"+str(seq))

for lh in sequence:
    f3.write(lh)
