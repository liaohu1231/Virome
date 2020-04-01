#! /bin/bash
###echo produce alignment through bowtie2
source activate bowtie
echo 'make bowtie database index'
database_path=/hwfssz1/ST_CANCER/CGR/USER/liaohu/metagenome/Human_VirDB/HVD
if [ ! -f $path/HGVD ];then bowtie2-build $path/HGVD.final.fasta $path/HGVD;fi
echo $database_path
echo "bowtie: mapping reads to assembly genome"

###从fastq到depth文件
database_path=/hwfssz1/ST_CANCER/CGR/USER/liaohu/metagenome/Human_VirDB/HVD
path_2=ERP017091_health
out=bowtie_health_result
sh_file=bowtie2_health.sh
if [ ! -d $out ];then echo "创建文件夹"; mkdir $out;fi

for i in $(ls $path_2/*_1.fastq|cut -d "/" -f 2|cut -d "_" -f 1);do 
echo $i;j=$(echo $path_2/${i}_1.fastq);k=$(echo $path_2/${i}_2.fastq)
echo source activate bowtie";" bowtie2 -p 10 -x $database_path/HGVD -1 $j -2 $k -S $out/$i.sam >> $sh_file;
echo samtools view -@ 10 -bS $out/$i.sam ">" $out/$i.bam"; "rm $out/$i.sam >> $sh_file; 
echo conda deactivate";"source activate gtdbtk";"coverm filter -b $out/$i.bam -o $out/$i"_filtered.bam" --min-read-percent-identity 0.95 -t 10";"rm $out/$i.bam >> $sh_file;###使用coverm对bam文件进行过滤，we filted out the read-percent-identity with less than 95%
echo samtools sort -@ 12 -o $out/$i.sorted $out/$i"_filtered.bam"";"rm $out/$i"_filtered.bam" >> $sh_file ###对过滤文件进行排序 
###计算depth
echo coverm contig -b $out/$i.sorted -m trimmed_mean -t 5 --min-covered-fraction 0.7 ">" $out/$i.depth >> $sh_file;done

cOMG qsubM -P P18Z10200N0098 -f 10G -p 4 -b 5 -N bowtie2 $sh_file

###将所有结果整合至一个矩阵
python merge_metaphlan_tables.py $out/*.depth > all.depth