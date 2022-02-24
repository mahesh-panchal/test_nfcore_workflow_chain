#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

include { NFCORE_FETCHNGS } from "$projectDir/subworkflows/fetchngs/main" addParams(
    outdir: "$params.outdir/fetchngs", 
    nf_core_pipeline: params.workflow
)
if ( params.workflow == 'rnaseq' ) {
    include { NFCORE_RNASEQ } from "$projectDir/subworkflows/rnaseq/main" addParams(
        input: "$params.outdir/fetchngs/samplesheet/samplesheet.csv", // This should be ignored as the samplesheet comes from the input channel, but may be necessary for parameter validation.
        outdir: "$params.outdir/rnaseq"
    )
} else if ( params.workflow == 'viralrecon' ) {
    include { NFCORE_VIRALRECON } from "$projectDir/subworkflows/viralrecon/main" addParams(
        input: "$params.outdir/fetchngs/samplesheet/samplesheet.csv", // This should be ignored as the samplesheet comes from the input channel, but may be necessary for parameter validation.
        outdir: "$params.outdir/viralrecon"
    )
}

workflow {
    NFCORE_FETCHNGS()
    if ( params.workflow == 'rnaseq' ) {
        NFCORE_RNASEQ( NFCORE_FETCHNGS.out.samplesheet )
    } else if ( params.workflow == 'viralrecon' ) {
        NFCORE_VIRALRECON ( NFCORE_FETCHNGS.out.samplesheet )
    }
}