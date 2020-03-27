source activate roary; blastn -db /hwfssz1/ST_CANCER/CGR/USER/liaohu/database/refseq_viral/refseq_viral_db -evalue 1e-10 -max_target_seqs 1 -query Hu_final.contig.res_3000.fa -num_threads 40 -out viral_db_evalue.txt -outfmt "6 qseqid sseqid pident qcovs length evalue"
python /hwfssz1/ST_CANCER/CGR/USER/liaohu/metagenome/Human_VirDB/HuVirDB/for_refseq_evalue.py
