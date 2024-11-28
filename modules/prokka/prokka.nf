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
    prokka_reference_argument = ""
    if( prokka_reference ) {
        prokka_reference_argument = "--proteins ${prokka_reference}"
    }

	genus = ""
	species = ""
	gramstain = ""
	
	if (classification) {
	
	script:
    """
    # Read the input line from the file
    line=\$(cat "$classification")

    # Split the line by tabs and assign variables
    IFS=\$'\t' read -r genus species gramstain <<< "\$line"

    # Output the variables for Nextflow
    echo \$genus \$species \$gramstain
    """
    
	}	

    prokka_gramstain_argument = ""
    if( prokka_signal_peptides ) {
        if( gramstain == "pos" ) {
            prokka_gramstain_argument = "--gram pos"
        } else if( gramstain == "neg" ) {
            prokka_gramstain_argument = "--gram neg"
        } else {
            prokka_gramstain_argument = ""
        }
    }

    prokka_genus_argument = "Undetermined"
    if( genus == "Unknown" ) {
        prokka_genus_argument = "--genus Unknown"
    } else if ( genus == "Mixed" ) {
        prokka_genus_argument = "--genus Mixed"
    } else {
        prokka_genus_argument = "--genus ${genus}"
    }

    prokka_species_argument = "sp."
    if( species == "unknown" || species == "sp." ) {
        prokka_species_argument = "--species Unknown"
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

