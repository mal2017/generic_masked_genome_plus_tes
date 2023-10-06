# generic_masked_genome_plus_tes

Expects a config containing the following:
    - GENOME_FASTA
    - HOST_GTF

Yields the following
    results/masked_genome_plus_tes/genome.masked.fasta
    results/masked_genome_plus_tes/transcripts_and_tes.gtf

## Configuration

Must include all configuration for any modules as well.

It has a default repeatmasker argument set, which can be overridden by editing the following portion of the config: `REPEATMASKER_ARGS`

Previous versions of this workflow only pulled TE seqs from DFAM. In the current version, you can optionally include a REPEAT_FASTA entry in the configfile. 
Detection of this entry skips the DFAM extraction step and allows you to use any fasta as an argument to the `-lib` param for `repeatmasker`. It is currently set
to a curated Dmel TE set made available at the [Bergman Lab github repo](https://github.com/bergmanlab/drosophila-transposons/tree/master).