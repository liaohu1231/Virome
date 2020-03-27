blastn -db db_path -evalue 1e-10 -max_target_seqs 1 -query Hu_final.contig.res_3000.fa -num_threads 40 -out evalue.txt -outfmt "6 qseqid sseqid pident qcovs length evalue"
