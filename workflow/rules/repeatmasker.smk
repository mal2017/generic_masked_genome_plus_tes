localrules: get_fastas, cat_genome_and_tes

rule get_genome_fasta:
    output:
        fasta = 'results/masked_genome_plus_tes/GENOME_FASTA.fasta'
    params:
        uri = lambda wc: config.get("GENOME_FASTA")
    shell:
        """
        curl {params.uri} > {output.fasta}
        """


rule repeatmasker:
    input:
        repeats = rules.dfam_collect_dfam.output.fa,
        fasta = rules.get_genome_fasta.output.fasta
    output:
        unmasked = 'results/masked_genome_plus_tes/repeatmasker/GENOME_FASTA.fasta.cat.gz',
        masked = 'results/masked_genome_plus_tes/repeatmasker/GENOME_FASTA.fasta.masked',
        out = 'results/masked_genome_plus_tes/repeatmasker/GENOME_FASTA.fasta.out',
        ori = 'results/masked_genome_plus_tes/repeatmasker/GENOME_FASTA.fasta.ori.out',
        gff = 'results/masked_genome_plus_tes/repeatmasker/GENOME_FASTA.fasta.out.gff',
        tbl ='results/masked_genome_plus_tes/repeatmasker/GENOME_FASTA.fasta.tbl',
    threads:
        24
    params:
        dir = "results/masked_genome_plus_tes/repeatmasker/",
        args = config.get("REPEATMASKER_ARGS")
    conda:
        "../envs/repeatmasker.yaml"
    resources:
        mem=128000,
        cpus=24,
        time=240,
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
        tes = rules.dfam_collect_dfam.output.fa,
    output:
        'results/masked_genome_plus_tes/masked_genome_plus_tes.fasta'
    conda:
        "../envs/samtools.yaml"
    shell:
        """
        cat {input.genome} {input.tes} > {output} &&
        samtools faidx {output}
        """