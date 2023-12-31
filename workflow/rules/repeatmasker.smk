rule repeatmasker:
    input:
        repeats = 'results/masked_genome_plus_tes/{asm}/REPEAT_FASTA.fasta',
        fasta = 'results/masked_genome_plus_tes/{asm}/GENOME_FASTA.fasta'
    output:
        unmasked = 'results/masked_genome_plus_tes/{asm}/repeatmasker/GENOME_FASTA.fasta.cat.gz',
        masked = 'results/masked_genome_plus_tes/{asm}/repeatmasker/GENOME_FASTA.fasta.masked',
        out = 'results/masked_genome_plus_tes/{asm}/repeatmasker/GENOME_FASTA.fasta.out',
        #ori = 'results/masked_genome_plus_tes/{asm}/repeatmasker/GENOME_FASTA.fasta.ori.out', sometimes it doesn't make this???
        gff = 'results/masked_genome_plus_tes/{asm}/repeatmasker/GENOME_FASTA.fasta.out.gff',
        tbl ='results/masked_genome_plus_tes/{asm}/repeatmasker/GENOME_FASTA.fasta.tbl',
    threads:
        48
    params:
        dir = "results/masked_genome_plus_tes/{asm}/repeatmasker/",
        args = '-e ncbi -no_is -s' #config.get("REPEATMASKER_ARGS")
    conda:
        "../envs/repeatmasker.yaml"
    resources:
        mem_mb=128000,
        cpus=48,
        runtime=360,
    shell:
        """
        RepeatMasker {params.args} -pa {threads} \
            -lib {input.repeats} -gff \
            -dir {params.dir} \
            {input.fasta}
        """

rule cat_genome_and_tes:
    input:
        genome = rules.repeatmasker.output.masked,
        tes = rules.get_custom_repeat_fasta.output.fasta,
    output:
        'results/masked_genome_plus_tes/{asm}/masked_genome_plus_tes.fasta'
    conda:
        "../envs/samtools.yaml"
    shell:
        """
        cat {input.genome} {input.tes} > {output} &&
        samtools faidx {output}
        """