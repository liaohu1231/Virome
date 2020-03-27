source activate VIBRANT
program=$(which VIBRANT_run.py)
workdir=$(cd $(dirname $0); pwd)
for i in $(ls HuVirDB/*.fa);do 
echo $i
python $program -i $i -t 20
done
