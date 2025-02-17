process FILTER_RESULTS {

    tag "${regenie_chromosomes.simpleName}"
    publishDir "${params.pubDir}/results/tophits", mode: 'copy'

    input:
    tuple val(phenotype), path(regenie_chromosomes)

    output:
    tuple val(phenotype), path("${phenotype}.regenie.filtered.gz"), emit: results_filtered

    // https://github.com/genepi/genomic-utils/blob/main/src/main/java/genepi/genomic/utils/commands/csv/CsvFilterCommand.java
    // removes rows where value of --filter-column < value of --limit
    // removes rows where value of --filter-column is in --ignore-list (not used below)
    // e.g. removes rows where LOG10P is below 7.3 (association is not strong enough)
    """
    java -jar /opt/genomic-utils.jar csv-filter \
        --separator '\t' \
        --output-sep '\t' \
        --input ${regenie_chromosomes} \
        --limit ${params.annotation_min_log10p} \
        --filter-column "LOG10P" \
        --gz \
        --output ${regenie_chromosomes.baseName}.tmp
    csvtk sort ${regenie_chromosomes.baseName}.tmp -t -kLOG10P:nr | gzip >  ${phenotype}.regenie.filtered.gz
    rm ${regenie_chromosomes.baseName}.tmp
    """
}