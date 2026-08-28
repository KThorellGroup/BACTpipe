process ASSEMBLY_STATS {
    tag "$pair_id"

    publishDir "${params.output_dir}/shovill", mode: 'copy'

    input:
    tuple val(pair_id), path(contigs_file)

    output:
    path "${pair_id}.assembly_stats.txt"

    script:
    """
    statswrapper.sh \
        in=${contigs_file} \
        > ${pair_id}.assembly_stats.txt
    """

    stub:
    """
    touch ${pair_id}.assembly_stats.txt
    """
}
