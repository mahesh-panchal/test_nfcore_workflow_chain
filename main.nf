#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

include { NFCORE_FETCHNGS } from "$projectDir/subworkflows/fetchngs/main" addParams(
        outdir: params.fetchngs_outdir, 
        nf_core_pipeline: 'rnaseq'
    )
// include { NFCORE_RNASEQ   } from "$projectDir/subworkflows/rnaseq/main"

workflow {
    NFCORE_FETCHNGS()
    // NFCORE_RNASEQ()   // How to run this after FETCHNGS ?
}