#!/usr/bin/env nextflow
// vim: syntax=groovy expandtab

nextflow.enable.dsl = 2

//================================================================================
// Log info
//================================================================================

log.info "".center(60, "=")
log.info "BACTpipe".center(60)
log.info "Version $workflow.manifest.version".center(60)
log.info "Bacterial whole genome analysis pipeline".center(60)
log.info "https://bactpipe.readthedocs.io".center(60)
log.info "".center(60, "=")

params.help = false

//================================================================================
// Include modules and (soft) override module-level parameters
//================================================================================

include { FASTP } from "./modules/fastp/fastp.nf"
include { CLASSIFY_TAXONOMY } from "./modules/classify_taxonomy/classify_taxonomy.nf"
include { SHOVILL } from "./modules/shovill/shovill.nf"
include { ASSEMBLY_STATS } from "./modules/assembly_stats/assembly_stats.nf"
include { PROKKA } from "./modules/prokka/prokka.nf"
include { MULTIQC } from "./modules/multiqc/multiqc.nf"
include { printHelp; printSettings } from "./modules/utils/utils.nf"

//================================================================================
// Pre-flight checks and info
//================================================================================

if (workflow['profile'] in params.profiles_that_require_project) {
    if (!params.project) {
        log.error "BACTpipe requires that you set the 'project' parameter when running the ${workflow['profile']} profile.\n".center(60) +
                "Specify --project <project_name> on the command line, or add it to a custom configuration file.".center(60) + 
                "Refer to the official docs for more information."
        exit(1)
    }
}

if (params.help) {
    printHelp()
    exit(0)
}

printSettings()

if ( ! params.kraken2_db ) {
	log.warn "No Kraken2 database specified. Use --kraken2_db /path/to/db to use Kraken2 to classify samples and determine gram stain."
}

if ( ! params.reads ) {
    log.error "No reads specified. It is required to specify --reads 'path/to/*_{1,2}.fastq.gz' (note the single quotes)"
    exit(1)
}

//================================================================================
// Prepare channels
//================================================================================

fastp_input = Channel.fromFilePairs(params.reads)

fastp_input
        .ifEmpty {
            log.error "Cannot find any reads matching: '${params.reads}'\n\n" +
                    "Did you specify --reads 'path/to/*_{1,2}.fastq.gz'? (note the single quotes)\n" +
                    "Specify --help for a summary of available commands. " +
                    "Refer to the official docs for more information."
            printHelp()
            exit(1)
        }

//================================================================================
// Main workflow
//================================================================================


workflow {
    FASTP(fastp_input)
    CLASSIFY_TAXONOMY(FASTP.out.fastq)
    SHOVILL(FASTP.out.fastq)
    ASSEMBLY_STATS(SHOVILL.out.contigs)

    prokka_ch = ((SHOVILL.out.contigs).join(CLASSIFY_TAXONOMY.out.classification), remainder: true)
	.map {assembly, classification -> tuple(assembly, classification?: [])} //If Kraken2 output is not available, run with empty input
    PROKKA(prokka_ch)

    MULTIQC(
        FASTP.out.fastp_reports.collect(),
        PROKKA.out.collect()
    )
}

//================================================================================
// Workflow onComplete action
//================================================================================

workflow.onComplete {
    log.info "".center(60, "=")
    log.info "BACTpipe workflow completed without errors".center(60)
    log.info "Check output files in folder:".center(60)
    log.info "${params.output_dir}".center(60)
    log.info "".center(60, "=")
}


workflow.onError {
    println "Oops... Pipeline execution stopped with the following message: ${workflow.errorMessage}".center(60, "=")
}

