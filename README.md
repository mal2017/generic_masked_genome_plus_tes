# generic_masked_genome_plus_tes

Expects a config containing the following:
    GENOME_FASTA
    HOST_GTF

Yields the following
    results/masked_genome_plus_tes/genome.masked.fasta
    results/masked_genome_plus_tes/transcripts_and_tes.gtf

## Configuration

Must include all configuration for any modules as well.

It has a default repeatmasker argument set, which can be overridden by editing the following portion of the config:
    REPEATMASKER_ARGS
