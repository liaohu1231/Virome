less prodigal_dereplicated_total_human_gut_virome_database_10000.faa|sed -n "/>/p"|cut -d " " -f 1 >> name.txt
less $1|sed -n "/>/p"|cut -d ' ' -f 1|while read line;do j=${line%_*};echo $j >> name_2.txt;done
paste -d , name.txt name_2.txt > g2g_2.txt
sed -i 's/$/,/g' g2g_2.txt
sed -i "s/$/not_provided/g" g2g_2.txt
echo protein_id,contig_id,keywords > title.txt
cat title.txt g2g_2.txt > g2g_10000.csv
sed -i 's/>//g' g2g_10000.csv
source activate vContact2
vcontact --raw-proteins prodigal_dereplicated_total_human_gut_virome_database.faa --pc-inflation 1.5 --vc-inflation 1.5 --rel-mode Diamond --proteins-fp g2g_10000.csv --db 'ProkaryoticViralRefSeq85-ICTV' --pcs-mode MCL --vcs-mode ClusterONE --output-dir vcontact_2/ --c1-bin /hwfssz5/ST_CANCER/CGR/USER/liaohu/soft/clusterone/cluster_one-1.0.jar 

###for intermediate
source activate vContact2
vcontact --pcs vConTACT_pcs.csv --contigs vConTACT_contigs.csv --pc-profiles vConTACT_profiles.csv --db 'ProkaryoticViralRefSeq97-Merged' --pcs-mode MCL --vcs-mode ClusterONE --c1-bin /hwfssz5/ST_CANCER/CGR/USER/liaohu/soft/clusterone/cluster_one-1.0.jar --pc-inflation 1.5 --vc-inflation 1.5 --output-dir vcontact_result2
