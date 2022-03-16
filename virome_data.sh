for i in $(ls */*/*/*combined.fna);do 
echo $i
j=${i%%/*};
k=${i%/*};
#if [ ! -f $j/$j"_10000.fna" ];then
python skip_short.py --input $i --skip_length 10000 --output $j/$j"_10000.fna";
python skip_long.py --input $k/*"circular.fna" --skip_length 10000 --output $j/$j"_circular.fna";
cat $j/$j"_10000.fna" $j/$j"_circular.fna" > $j/$j".filter1.fasta"
#prodigal -a $j/$j".filter1.faa" -i $j/$j".filter1.fasta"
#fi
done
