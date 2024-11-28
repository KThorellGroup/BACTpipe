
process ASSEMBLY_STATS {
    tag { pair_id }
    publishDir "${params.output_dir}/shovill", mode: 'copy'

    input:
    tuple val(pair_id), path("${pair_id}.contigs.fa")

    output:
    path("${pair_id}.assembly_stats.txt")

    script:
    """
    statswrapper.sh \
        in=${pair_id}.contigs.fa \
        > ${pair_id}.assembly_stats.txt        
    """

    stub:
    """
    touch ${pair_id}.assembly_stats.txt
    """
}
