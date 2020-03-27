source activate VIBRANT
for i in $(ls HuVirDB/HuVirDB.fa);do 
echo $i
python VIBRANT_run.py -i $i -t 20
done
