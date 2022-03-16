#!/bin/sh
for i in $(ls */*.faa);do 
j=${i%%/*}
if [ ! -f $j/$j"_phage_hmmout.txt" ];then
if [ ! -f $j/$j"_phage_hmmout.txt.filter.fna" ];then 
hmmsearch --cpu 64 -E 1.0e-05 --tblout $j/$j"_phage_hmmout.txt" /public3/home/sc52870/database/final_list.hmms $i
fi
fi
done
