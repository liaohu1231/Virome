#! /bin/bash
###echo produce alignment through bowtie2

echo 'make bowtie database index'
if [ ! -d bowtie2_database/ ];then mkdir bowtie2_database/; bowtie2-build $1 bowtie2_database/$1;fi
echo $database_path

echo "bowtie: mapping reads to assembly genome"
###从fastq到depth文件
out=bowtie_result
if [ ! -d $out ];then mkdir $out;fi

for i in $(ls -d $2);do 
echo $i;
bowtie2 -p $3 -x bowtie2_database/$1 -1 $i/output_forward_paired.fq.gz -2 $i/output_reverse_paired.fq.gz -S $out/$i.sam
samtools view -@ $3 -bS $out/$i.sam > $out/$i.bam
rm $out/$i.sam 
coverm filter -b $out/$i.bam -o $out/$i"_filtered.bam" --min-read-percent-identity 0.95 -t 10;
rm $out/$i.bam ###使用coverm对bam文件进行过滤，we filted out the read-percent-identity with less than 95%
samtools sort -@ $3 -o $out/$i.sorted $out/$i"_filtered.bam
rm $out/$i"_filtered.bam" ###对过滤文件进行排序 
###计算depth
coverm contig -b $out/$i.sorted -m trimmed_mean -t 5 --min-covered-fraction 0.7 > $out/$i.depth
done
nohup $sh_file

echo "将所有结果整合至一个矩阵"
python merge_metaphlan_tables.py $out/*.depth > $out/all.depth
