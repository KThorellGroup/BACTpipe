
def printHelp() {
    log.info """
  Example usage:
    nextflow run KThorellGroup/BACTpipe --reads '*_R{1,2}.fastq.gz'

  Mandatory arguments:
    --reads                 Path to input data (must be surrounded with single quotes).

  Optional arguments:
    --kraken2_db            Path to Kraken2 database for taxonomic classification and gram
                            stain determination (recommended!).
    --keep_trimmed_fastq    Save trimmed fastq files in output directory (default: ${params.keep_trimmed_fastq}).
    --keep_shovill_output   Save all shovill output in output directory (default: ${params.keep_shovill_output}).

  Output options:
    --output_dir            Output directory, where results will be saved 
                            (default: ${params.output_dir}).

  Refer to the online manual for more information and all available options:
             https://bactpipe.readthedocs.io
  """
}

def printSettings() {
    log.info "Running with the following settings:".center(60)

    params.each { key, value ->
        if (!(key in ['clusterOptions', 'help', 'profiles_that_require_project'])) {
            log.info "${key}: ".padLeft(30) + "${value}"
        }
    }

    log.info "".center(60, "=")
}
