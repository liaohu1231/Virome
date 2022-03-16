from glob import glob
from Bio import SeqIO
import os
import argparse

parser = argparse.ArgumentParser(description='skip is an automatic splitor.')
basic_group = parser.add_argument_group('Basic options')
basic_group.add_argument("--input", dest="inputfile", type=str, required=True, help='Input file as a FASTA file', metavar="FASTAFILE")
basic_group.add_argument("--skip_length", dest="length", type=int, default=1000, help='The length of contigs less than the length bp was removed')
basic_group.add_argument("--model", dest="model", type=str, default='longer', help='The model of filter include shorter and longer')
basic_group.add_argument("--output", dest="outputfile", type=str, required=True, help='Output file as a FASTA file', metavar="FASTAFILE")

args = parser.parse_args()
out=open(args.outputfile,"w+")
for seq_record in SeqIO.parse(args.inputfile, "fasta"):
	if str(args.model)=="longer":
		#print(len(seq_record))
		if len(seq_record) >= args.length:
			SeqIO.write(seq_record,out,"fasta")
			out.flush()
	else:
		if len(seq_record) <= args.length:
			SeqIO.write(seq_record,out,"fasta")
			out.flush()
