#!/usr/bin/env nextflow
/*
========================================================================================
    nf-core/rnaseq
========================================================================================
    Github : https://github.com/nf-core/rnaseq
    Website: https://nf-co.re/rnaseq
    Slack  : https://nfcore.slack.com/channels/rnaseq
----------------------------------------------------------------------------------------
*/

nextflow.enable.dsl = 2

/*
========================================================================================
    GENOME PARAMETER VALUES
========================================================================================
*/

params.fasta         = WorkflowMain.getRnaseqGenomeAttribute(params, 'fasta')
params.gtf           = WorkflowMain.getRnaseqGenomeAttribute(params, 'gtf')
params.gff           = WorkflowMain.getRnaseqGenomeAttribute(params, 'gff')
params.gene_bed      = WorkflowMain.getRnaseqGenomeAttribute(params, 'bed12')
params.bbsplit_index = WorkflowMain.getRnaseqGenomeAttribute(params, 'bbsplit')
params.star_index    = WorkflowMain.getRnaseqGenomeAttribute(params, 'star')
params.hisat2_index  = WorkflowMain.getRnaseqGenomeAttribute(params, 'hisat2')
params.rsem_index    = WorkflowMain.getRnaseqGenomeAttribute(params, 'rsem')
params.salmon_index  = WorkflowMain.getRnaseqGenomeAttribute(params, 'salmon')

/*
========================================================================================
    VALIDATE & PRINT PARAMETER SUMMARY
========================================================================================
*/

WorkflowMain.initialise(workflow, params, log)

/*
========================================================================================
    NAMED WORKFLOW FOR PIPELINE
========================================================================================
*/

include { RNASEQ } from './workflows/rnaseq'

//
// WORKFLOW: Run main nf-core/rnaseq analysis pipeline
//
workflow NFCORE_RNASEQ {

    take:
    samplesheet

    main:
    RNASEQ ( samplesheet )
}

/*
========================================================================================
    RUN ALL WORKFLOWS
========================================================================================
*/

//
// WORKFLOW: Execute a single named workflow for the pipeline
// See: https://github.com/nf-core/rnaseq/issues/619
//
workflow {
    NFCORE_RNASEQ ( Channel.empty() )
}

/*
========================================================================================
    THE END
========================================================================================
*/
