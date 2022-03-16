# These script depended R,shell or python3 to run

#1. use tool vibrant to identify the viral genomes from assembly fasta files

for i in $(ls -f $1);
do echo $i;
j=${i%/*}
VIBRANT_run.py -i $i -t 64 -folder vibrant_phage/phage_$j/
done

2.virome_data_run.py: The script used to remove false positive viral 
genomes identified from vibrant. the input file is an output fna file from vibrant.

3.skip.py: The script used to filte viral genomes greater or less the
setted length threshold.

4.microdiversity/classified_population.R: The script used to classfy the geographic
distribution of viral populations as multi-zonal, regional or local.

5.microdiversity/microdiveristy.R: The script used to calculate the 
average microdiversity of multi-zonal, regional or local viral populations
in each samples.

6.microdiveristy/microdiveristy_multi.R: The script used to calculate
the average microdiversity of multi-zonal viral populations in each samples.

7.microdiveristy/pNpS.R: The script used to calculate the average pNpS value
of multi-zonal, regional or local viral populations in each samples.

8.microdiveristy/all_positive_gene.R:  The script used to calculate the positive selected genes
