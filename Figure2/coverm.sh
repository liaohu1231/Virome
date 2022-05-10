#!/bin/sh
'''
conda activate coverm
echo 'make bowtie database index'
if [ ! -d bowtie2_database_gene/ ];then mkdir bowtie2_database_gene/;
bowtie2-build $1 bowtie2_database_gene/$1;fi
echo "bowtie: mapping reads to assembly genome"
'''

###从fastq到depth文件
out=$2
if [ ! -d $out ];then mkdir $out;fi
for i in $(ls -d ly*/*/);do 
echo $i;
j=${i%/*}
k=${j#*/}

if [ -f "$j"/*R1.3000*gz ];then
right=$(ls $i*3000*.gz|sed -n "/R1\./p")
left=$(ls $i*3000*.gz|sed -n "/R2\./p")
if [ ! -f $out/$k.depth ];then
bowtie2 -p 64 --non-deterministic -x $1 --very-sensitive -1 $right -2 $left -S $out/$k.sam
samtools view -@ 64 -bS $out/$k.sam > $out/$k.bam
coverm filter -b $out/$k.bam -o $out/$k"_filtered.bam" --min-read-aligned-percent 0.95 -t 10
samtools sort -@ 64 -o $out/$k.sorted $out/$k"_filtered.bam"
coverm contig -b $out/$k.sorted -m rpkm -t 10 --min-covered-fraction 0.7 > $out/$k.depth;
fi
fi
done


