rule get_te_gtf:
    input:
        fasta = rules.dfam_collect_dfam.output.fa if USE_DFAM else rules.get_custom_repeat_fasta.output.fasta,
    output:
        fai = rules.dfam_collect_dfam.output.fa  + '.fai' if USE_DFAM else rules.get_custom_repeat_fasta.output.fasta + '.fai',
        bed = 'results/masked_genome_plus_tes/custom_transcriptome/REPEAT_FASTA.bed',
        gp = "results/masked_genome_plus_tes/custom_transcriptome/REPEAT_FASTA.gp",
        gtf = 'results/masked_genome_plus_tes/custom_transcriptome/REPEAT_FASTA.consensus.gtf',
    conda:
        "../envs/te_gtf.yaml"
    shell:
        """
        samtools faidx {input.fasta} &&

        bedtools makewindows -g {output.fai} -n 1 -i src > {output.bed} &&

        bedToGenePred {output.bed} stdout | awk 'BEGIN{{FS=OFS="\t"}} {{$3="+"}} 1' > {output.gp}

        genePredToGtf file {output.gp} stdout -source='CUSTOM' | gffread -T | grep 'exon' > {output.gtf}
        """

rule get_gtf:
    output:
        gtf = 'results/masked_genome_plus_tes/transcriptome.gtf'
    params:
        uri = lambda wc: config.get("HOST_GTF")
    shell:
        """
        if [[ "{params.uri}" == *.gz ]]; then
            curl {params.uri} | gunzip -c > {output.gtf}
        else
            curl {params.uri} > {output.gtf}
        fi
        """


rule make_transcripts_and_consensus_tes_gtf:
    """
    A few small cleaning steps to make the host txome and TE gtf files compatible with
    salmon other downstream steps..s
    """
    input:
        host_gtf = rules.get_gtf.output.gtf,
        te_gtf = rules.get_te_gtf.output.gtf,
    output:
        gtf = "results/masked_genome_plus_tes/transcriptome_plus_tes.gtf",
    conda:
        "../envs/rtracklayer.yaml"
    script:
        "../scripts/make_transcripts_and_consensus_tes_gtf.R"


rule make_transcripts_and_consensus_tes_tx2gene:
    """
    We generated the combined transcriptome reference by concatenating the set of transcript
    sequences and the set of consensus TE sequences.
    """
    input:
        gtf = rules.make_transcripts_and_consensus_tes_gtf.output.gtf,
    output:
        tx2id = "results/masked_genome_plus_tes/transcriptome_plus_tes.tx2id.tsv",
    conda:
        "../envs/rtracklayer.yaml"
    script:
        "../scripts/make_transcripts_and_consensus_tes_tx2gene.R"

rule get_transcript_fasta:
    output:
        fasta = 'results/masked_genome_plus_tes/TRANCRIPT_FASTA.fasta'
    params:
        uri = lambda wc: config.get("TRANSCRIPT_FASTA")
    shell:
        """
        if [[ "{params.uri}" == *.gz ]]; then
            curl {params.uri} | gunzip -c > {output.fasta}
        else
            curl {params.uri} > {output.fasta}
        fi
        """
rule make_transcripts_and_consensus_tes_fa:
    input:
        tes = rules.dfam_collect_dfam.output.fa if USE_DFAM else rules.get_custom_repeat_fasta.output.fasta,
        transcripts = rules.get_transcript_fasta.output.fasta,
    output:
        fasta = "results/masked_genome_plus_tes/transcriptome_plus_tes.fasta",
    shell:
        """
        cat {input.transcripts} {input.tes} > {output.fasta}
        """