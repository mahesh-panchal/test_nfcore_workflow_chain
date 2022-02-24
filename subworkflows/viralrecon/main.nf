#!/usr/bin/env nextflow
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    nf-core/viralrecon
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Github : https://github.com/nf-core/viralrecon
    Website: https://nf-co.re/viralrecon
    Slack  : https://nfcore.slack.com/channels/viralrecon
----------------------------------------------------------------------------------------
*/

nextflow.enable.dsl = 2

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    GENOME PARAMETER VALUES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

def primer_set         = ''
def primer_set_version = 0
if (params.platform == 'illumina' && params.protocol == 'amplicon') {
    primer_set         = params.primer_set
    primer_set_version = params.primer_set_version
} else if (params.platform == 'nanopore') {
    primer_set          = 'artic'
    primer_set_version  = params.primer_set_version
    params.artic_scheme = WorkflowMain.getViralreconGenomeAttribute(params, 'scheme', log, primer_set, primer_set_version)
}

params.fasta         = WorkflowMain.getViralreconGenomeAttribute(params, 'fasta'     , log, primer_set, primer_set_version)
params.gff           = WorkflowMain.getViralreconGenomeAttribute(params, 'gff'       , log, primer_set, primer_set_version)
params.bowtie2_index = WorkflowMain.getViralreconGenomeAttribute(params, 'bowtie2'   , log, primer_set, primer_set_version)
params.primer_bed    = WorkflowMain.getViralreconGenomeAttribute(params, 'primer_bed', log, primer_set, primer_set_version)

params.nextclade_dataset           = WorkflowMain.getViralreconGenomeAttribute(params, 'nextclade_dataset'          , log, primer_set, primer_set_version)
params.nextclade_dataset_name      = WorkflowMain.getViralreconGenomeAttribute(params, 'nextclade_dataset_name'     , log, primer_set, primer_set_version)
params.nextclade_dataset_reference = WorkflowMain.getViralreconGenomeAttribute(params, 'nextclade_dataset_reference', log, primer_set, primer_set_version)
params.nextclade_dataset_tag       = WorkflowMain.getViralreconGenomeAttribute(params, 'nextclade_dataset_tag'      , log, primer_set, primer_set_version)

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    VALIDATE & PRINT PARAMETER SUMMARY
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

WorkflowMain.initialise(workflow, params, log)

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NAMED WORKFLOW FOR PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

if (params.platform == 'illumina') {
    include { ILLUMINA } from './workflows/illumina'
} else if (params.platform == 'nanopore') {
    include { NANOPORE } from './workflows/nanopore'
}

workflow NFCORE_VIRALRECON {

    take:
    samplesheet

    main:
    //
    // WORKFLOW: Variant and de novo assembly analysis for Illumina data
    //
    if (params.platform == 'illumina') {
        ILLUMINA ( samplesheet )

    //
    // WORKFLOW: Variant analysis for Nanopore data
    //
    } else if (params.platform == 'nanopore') {
        NANOPORE ( samplesheet )
    }
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN ALL WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// WORKFLOW: Execute a single named workflow for the pipeline
// See: https://github.com/nf-core/rnaseq/issues/619
//

workflow {
    NFCORE_VIRALRECON ( Channel.empty() )
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
