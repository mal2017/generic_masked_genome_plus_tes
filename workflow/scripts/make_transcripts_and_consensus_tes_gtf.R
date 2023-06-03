library(rtracklayer)

#gtffile <- "results/masked_genome_plus_tes/transcriptome.gtf"
gtffile <- snakemake@input[["host_gtf"]]

tx <- import(gtffile)

#te_gtf_file <- "results/masked_genome_plus_tes/custom_transcriptome/REPEAT_FASTA.consensus.gtf"
te_gtf_file <- snakemake@input$te_gtf
te_gtf <- import(te_gtf_file)

te_gtf$type <- "mRNA"
te_gtf$gene_symbol <- te_gtf$gene_id
te_gtf$transcript_symbol <- te_gtf$transcript_id
te_gtf$gene_name <- te_gtf$gene_id
te_gtf$transcript_name <- te_gtf$transcript_id


# make final combined gr
combined <- c(tx, te_gtf)

combined$`#` <- NULL

# write to disk
export(combined,snakemake@output[["gtf"]])