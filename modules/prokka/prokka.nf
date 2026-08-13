process PROKKA {
    tag "$pair_id"

    publishDir "${params.output_dir}/prokka", mode: 'copy'

    input:
    tuple val(pair_id), path(contigs_file), path(classification_file)

    output:
    path "${pair_id}_prokka"

    script:
    def prokka_reference_argument = ""
    if (params.prokka_reference) {
        prokka_reference_argument = "--proteins ${params.prokka_reference}"
    }

    def classification_data =
        file(classification_file.resolveSymLink()).getText().split("\t")

    def genus = classification_data[0]
    def species = classification_data[1]
    def gramstain = classification_data[2]

    def prokka_gramstain_argument = ""
    if (params.prokka_signal_peptides) {
        if (gramstain == "pos") {
            prokka_gramstain_argument = "--gram pos"
        }
        else if (gramstain == "neg") {
            prokka_gramstain_argument = "--gram neg"
        }
    }

    def prokka_genus_argument
    if (genus == "Unknown") {
        prokka_genus_argument = "--genus Unknown"
    }
    else if (genus == "Mixed") {
        prokka_genus_argument = "--genus Mixed"
    }
    else {
        prokka_genus_argument = "--genus ${genus}"
    }

    def prokka_species_argument
    if (species == "unknown" || species == "spp.") {
        prokka_species_argument = "--species Unknown"
    }
    else {
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
