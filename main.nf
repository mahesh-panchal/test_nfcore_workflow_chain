#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

include { NFCORE_FETCHNGS } from 'subworkflows/fetchngs/main' 
    addParams(
        input: params.fetchngs_input,
        outdir: params.fetchngs_outdir, 
        nf_core_pipeline: rnaseq
    )
include { NFCORE_RNASEQ   } from 'subworkflows/rnaseq/main'   
    addParams(
        input: '' // Need the output from one into the other.
        outdir: params.rnaseq_outdir 
    )

workflow {
    NFCORE_FETCHNGS()
    NFCORE_RNASEQ()   // How to run this after FETCHNGS ?
}