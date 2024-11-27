
process SHOVILL {
    tag { pair_id }
    publishDir "${params.output_dir}/shovill", mode: 'copy', pattern: "${pair_id}_shovill/*.log"
    publishDir "${params.output_dir}/shovill", mode: 'copy', pattern: "${pair_id}_shovill/*.{fasta,fastg,fa,gfa,changes,hist,tab}", enabled: params.keep_shovill_output

    input:
    tuple val(pair_id), path(reads)

    output:
    tuple val(pair_id), path("${pair_id}_contigs.fa"), emit: contigs
    path("${pair_id}_shovill/*.{fasta,fastg,log,fa,gfa,changes,hist,tab}")

    script:
    """
    shovill \
         --depth ${params.shovill_depth} \
         --minlen ${params.shovill_minlen} \
         --cpus ${task.cpus} \
         --R1 ${reads[0]} \
         --R2 ${reads[1]} \
         --outdir ${pair_id}_shovill

    rename_fasta.py \
		--input ${pair_id}_shovill/contigs.fa \
		--output ${pair_id}_contigs.fa \
		--pre ${pair_id}_contig
    """

    stub:
    """
    mkdir ${pair_id}_shovill/
    touch ${pair_id}_shovill/${pair_id}.fasta
    touch ${pair_id}_shovill/${pair_id}.fastg
    touch ${pair_id}_shovill/${pair_id}.log
    touch ${pair_id}_shovill/${pair_id}.fa
    touch ${pair_id}_shovill/${pair_id}.gfa
    touch ${pair_id}_shovill/${pair_id}.changes
    touch ${pair_id}_shovill/${pair_id}.hist
    touch ${pair_id}_shovill/${pair_id}.tab

    touch ${pair_id}_contigs.fa
    """
}
