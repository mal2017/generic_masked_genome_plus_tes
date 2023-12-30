# generic_masked_genome_plus_tes

Expects a config containing the following:
    - GENOME_FASTA
    - HOST_GTF
    - REPEAT_FASTA

Yields the following
    results/masked_genome_plus_tes/genome.masked.fasta
    results/masked_genome_plus_tes/transcripts_and_tes.gtf

## Configuration

It has a default repeatmasker argument set, which can be overridden by editing the following portion of the config: `REPEATMASKER_ARGS`

## Use of generic_dfam_extract workflow or other in-workflow sources of TEs

Previous versions of this pipeline included the module github://mal2017/generic_dfam_extract @ commit 23fc6f8. This nested module import approach caused major problems when importing this module into some other workflows. This has been removed on a trial basis, and any downstream workflows that want to use both in concert will have to import both separately, and then modify the `params` and/or `input` directives of the rules in `workflow/rules/getters.smk` to bypass looking for URIs in the config, and instead look for this in generic_dfam_extract or some other rule's output.

For example, to rewire this to take some locally produced genome (e.g. a _de novo_ assembly), you could add an `input` directive and modify the `params` directive in the same pattern as the following example.

```
use rule get_genome_fasta from generic_masked_genome_plus_tes with:
    input:
        uri = rules.something_else.output
    params:
        uri = rules.something_else.output
```