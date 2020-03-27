#!/usr/bin/env python
import os
import subprocess
subprocess.call(['blastn', '-db', 'db_path', '-evalue', '1e-10', '-max_target_seqs', '1', '-query Hu_final.contig.res_3000.fa', '-num_threads', '40', '-out', 'evalue.txt' '-outfmt', '6 qseqid sseqid pident qcovs length evalue'])
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
