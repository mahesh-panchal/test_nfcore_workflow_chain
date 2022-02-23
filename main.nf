#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

include { NFCORE_FETCHNGS } from "$projectDir/subworkflows/fetchngs/main" addParams(
    outdir: "$params.outdir/fetchngs", 
    nf_core_pipeline: 'rnaseq'
)
include { NFCORE_RNASEQ   } from "$projectDir/subworkflows/rnaseq/main" addParams(
    input: "$params.outdir/fetchngs/samplesheet/samplesheet.csv", // This should be ignored as the samplesheet comes from the input channel, but may be necessary for parameter validation.
    outdir: "$params.outdir/rnaseq"
)

workflow {
    NFCORE_FETCHNGS()
    NFCORE_RNASEQ( NFCORE_FETCHNGS.out.samplesheet )
}