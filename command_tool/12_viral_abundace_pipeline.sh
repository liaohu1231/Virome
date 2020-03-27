###echo produce alignment through bowtie2
source activate bowtie
echo 'make bowtie database index'
path=/hwfssz1/ST_CANCER/CGR/USER/liaohu/metagenome/Human_VirDB/HVD
bowtie2-build $path/HGVD_vcontact2_database.fasta $path/HGVD
echo $path
echo "bowtie: mapping reads to assembly genome"

###进行bowtie2比对
for i in $(ls ERP013563_fastq/*_1.fastq|cut -d "/" -f 2|cut -d "_" -f 1);do 
echo $i;j=$(echo ERP013563_fastq/${i}_1.fastq);k=$(echo ERP013563_fastq/${i}_2.fastq)
echo bowtie2 -p 50 -x $path/HGVD -1 $j -2 $k -S bowtie_result/$i.sam >> bowtie2.sh;done
bash bowtie2.sh

###转换数据格式
echo 'transform data format'
date >> time.txt
for i in $(ls *.sam);do j = $(ls *.sam|sed -n "/$i/p"|cut -d "." -f 1);
samtools view -bS $i > $j".bam"
rm $i
done

###使用coverm对bam文件进行过滤，we filted out the read-percent-identity with less than 95%
for i in $(ls *.bam);do j=$(ls *.bam|sed -n "/$i/p"|cut -d "." -f 1);
echo source activate gtdbtk";"coverm filter -b $i -o $j"_filtered.bam" --min-read-percent-identity 0.95 -t 12";"rm $i >> coverm_run.sh;
done
bash coverm_run.sh

###对过滤文件进行排序
for i in $(ls *_filtered.bam);do samtools sort -@ 12 -o $i.sorted $i;done 

###使用bedtools genomecov 进行覆盖度（coverage）的计算
for i in $(ls *.sorted);do if [ ! -f $.cov_result ];then bedtools genomecov -ibam $i > $i.cov_result;fi;done

###计算depth
source activate gtdbtk;for i in $(ls *.sorted);do coverm contig -b $i -m trimmed_mean -t 5 --min-covered-fraction 0.7 > $i.depth;done

###将所有结果整合至一个矩阵
python merge_metaphlan_tables.py


