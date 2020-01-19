less prodigal_dereplicated_total_human_gut_virome_database.faa|sed -n "/>/p"|cut -d " " -f 1 >> name.txt
less prodigal_dereplicated_total_human_gut_virome_database.faa|sed -n "/>/p"|cut -d "." -f 1 >> name_2.txt
paste -d , name.txt name_2.txt > g2g.txt
sed -i 's/$/,/g' g2g.txt
sed -i "s/$/not_provided/g" g2g.txt
touch title.txt
echo protein_id,contig_id,keywords > title.txt
cat title.txt g2g.txt > g2g_2.csv

#vcontact --raw-proteins [proteins file] --rel-mode ‘Diamond’ --proteins-fp [gene-to-genome mapping file] --db 'ProkaryoticViralRefSeq94-Merged' --pcs-mode MCL --vcs-mode ClusterONE --c1-bin [path to ClusterONE] --output-dir [target output directory]
source activate vContact2
vcontact --raw-proteins prodigal_dereplicated_total_human_gut_virome_database.faa --pc-inflation 1.5 --vc-inflation 1.5 --rel-mode Diamond --proteins-fp g2g_2.csv --db 'ProkaryoticViralRefSeq85-ICTV' --pcs-mode MCL --vcs-mode ClusterONE --output-dir vcontact/ --c1-bin /hwfssz5/ST_CANCER/CGR/USER/liaohu/soft/anaconda3/bin/ 
