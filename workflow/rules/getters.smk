localrules: cat_genome_and_tes, get_custom_repeat_fasta, get_genome_fasta


rule get_gtf:
    params: 
        uri = lambda wc: config['ASSEMBLIES'].get(wc.asm).get("HOST_GTF")
    output:
        gtf = 'results/masked_genome_plus_tes/{asm}/transcriptome.gtf'
    shell:
        """
        if [[ "{params.uri}" == *.gz ]]; then
            curl {params.uri} | gunzip -c > {output.gtf}
        else
            curl {params.uri} > {output.gtf}
        fi
        """

rule get_custom_repeat_fasta:
    params:
        uri = lambda wc: config['ASSEMBLIES'].get(wc.asm).get("REPEAT_FASTA")
    output:
        fasta = 'results/masked_genome_plus_tes/{asm}/REPEAT_FASTA.fasta'
    shell:
        """
        if [[ "{params.uri}" == *.gz ]]; then
            curl {params.uri} | gunzip -c > {output.fasta}
        else
            curl {params.uri} > {output.fasta}
        fi
        """


rule get_genome_fasta:
    params:
        uri = lambda wc: config['ASSEMBLIES'].get(wc.asm).get("GENOME_FASTA")
    output:
        fasta = 'results/masked_genome_plus_tes/{asm}/GENOME_FASTA.fasta'
    shell:
        """
        if [[ "{params.uri}" == *.gz ]]; then
            curl {params.uri} | gunzip -c > {output.fasta}
        else
            curl {params.uri} > {output.fasta}
        fi
        """

rule get_transcript_fasta:
    output:
        fasta = 'results/masked_genome_plus_tes/{asm}/TRANCRIPT_FASTA.fasta'
    params:
        uri = lambda wc: config["ASSEMBLIES"].get(wc.asm).get("TRANSCRIPT_FASTA")
    shell:
        """
        if [[ "{params.uri}" == *.gz ]]; then
            curl {params.uri} | gunzip -c > {output.fasta}
        else
            curl {params.uri} > {output.fasta}
        fi
        """