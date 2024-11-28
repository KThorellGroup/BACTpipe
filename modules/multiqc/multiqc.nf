
process MULTIQC {
    publishDir "${params.output_dir}/multiqc", mode: 'copy'

    input:
    path('*.json')
    path('assembly_metrics_mqc.tsv')
    path('*_prokka')

    output:
    path('multiqc_report.html')

    script:
    """
    multiqc *.json */*.txt --filename multiqc_report.html
    """

    stub:
    """
    touch multiqc_report.html
    """
}
