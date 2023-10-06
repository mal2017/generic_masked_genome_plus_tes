localrules: get_fastas, cat_genome_and_tes

rule get_custom_repeat_fasta:
    output:
        fasta = 'results/masked_genome_plus_tes/REPEAT_FASTA.fasta'
    params:
        uri = lambda wc: config.get("REPEAT_FASTA")
    shell:
        """
        if [[ "{params.uri}" == *.gz ]]; then
            curl {params.uri} | gunzip -c > {output.fasta}
        else
            curl {params.uri} > {output.fasta}
        fi
        """


rule get_genome_fasta:
    output:
        fasta = 'results/masked_genome_plus_tes/GENOME_FASTA.fasta'
    params:
        uri = lambda wc: config.get("GENOME_FASTA")
    shell:
        """
        if [[ "{params.uri}" == *.gz ]]; then
            curl {params.uri} | gunzip -c > {output.fasta}
        else
            curl {params.uri} > {output.fasta}
        fi
        """


rule repeatmasker:
    input:
        repeats = rules.dfam_collect_dfam.output.fa if USE_DFAM else rules.get_custom_repeat_fasta.output.fasta,
        fasta = rules.get_genome_fasta.output.fasta
    output:
        unmasked = 'results/masked_genome_plus_tes/repeatmasker/GENOME_FASTA.fasta.cat.gz',
        masked = 'results/masked_genome_plus_tes/repeatmasker/GENOME_FASTA.fasta.masked',
        out = 'results/masked_genome_plus_tes/repeatmasker/GENOME_FASTA.fasta.out',
        #ori = 'results/masked_genome_plus_tes/repeatmasker/GENOME_FASTA.fasta.ori.out', sometimes it doesn't make this???
        gff = 'results/masked_genome_plus_tes/repeatmasker/GENOME_FASTA.fasta.out.gff',
        tbl ='results/masked_genome_plus_tes/repeatmasker/GENOME_FASTA.fasta.tbl',
    threads:
        48
    params:
        dir = "results/masked_genome_plus_tes/repeatmasker/",
        args = config.get("REPEATMASKER_ARGS")
    conda:
        "../envs/repeatmasker.yaml"
    resources:
        mem=128000,
        cpus=48,
        time=360,
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
        tes = rules.dfam_collect_dfam.output.fa if USE_DFAM else rules.get_custom_repeat_fasta.output.fasta,
    output:
        'results/masked_genome_plus_tes/masked_genome_plus_tes.fasta'
    conda:
        "../envs/samtools.yaml"
    shell:
        """
        cat {input.genome} {input.tes} > {output} &&
        samtools faidx {output}
        """