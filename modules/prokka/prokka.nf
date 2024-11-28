nextflow.enable.dsl = 2

process PROKKA {
    tag { pair_id }
    publishDir "${params.output_dir}/prokka", mode: 'copy'

    input:
    tuple val(pair_id), path(contigs_file), path(classification)
    path(prokka_reference)
    val(prokka_signal_peptides)

    output:
    path("${pair_id}_prokka")

    script:
    // Default values
    def genus = "Undetermined"
    def species = "undetermined"
    def gramstain = ""

    if (classification) {
        // Parse the classification file (assumes one line with tab-separated values)
        def classification_line = classification.text.trim()
        def fields = classification_line.split("\t")
        
        // Assign fields if they exist
        if (fields.size() > 0) genus = fields[0]
        if (fields.size() > 1) species = fields[1]
        if (fields.size() > 2) gramstain = fields[2]
    }
    
    // Prepare optional arguments for Prokka
    def prokka_reference_argument = prokka_reference ? "--proteins ${prokka_reference}" : ""
    
    def prokka_gramstain_argument = ""
    if (prokka_signal_peptides) {
        if (gramstain == "pos") {
            prokka_gramstain_argument = "--gram pos"
        } else if (gramstain == "neg") {
            prokka_gramstain_argument = "--gram neg"
        }
    }

    def prokka_genus_argument = ""
    if (genus == "Unknown") {
        prokka_genus_argument = "--genus Unknown"
    } else if (genus == "Mixed") {
        prokka_genus_argument = "--genus Mixed"
    } else if (genus != "Undetermined") {
        prokka_genus_argument = "--genus ${genus}"
    }

    def prokka_species_argument = ""    
    if( species == "unknown" || species == "ssp." ) {
        prokka_species_argument = "--species unknown"
    } else {
        prokka_species_argument = "--species ${species}"
    }

    """
    prokka \
        --cpus ${task.cpus} \
        --force \
        --evalue ${params.prokka_evalue} \
        --kingdom ${params.prokka_kingdom} \
        --locustag ${pair_id} \
        --outdir ${pair_id}_prokka \
        --prefix ${pair_id} \
        --strain ${pair_id} \
        ${prokka_reference_argument} \
        ${prokka_gramstain_argument} \
        ${prokka_genus_argument} \
        ${prokka_species_argument} \
        ${contigs_file}
    """

    stub:
    """
    mkdir ${pair_id}_prokka
    """
}
