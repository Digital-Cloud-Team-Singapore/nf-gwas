process QC_FILTER_GENOTYPED {

    publishDir "${params.pubDir}/logs", mode: 'copy', pattern: '*.qc.log'

    input:
    // tuple val(genotyped_plink_filename), path(genotyped_plink_file)
    file genotyped_plink_file_bed
    file genotyped_plink_file_bim
    file genotyped_plink_file_fam

    // suspicion: need to move output section to below script?? lol
    // it might not be recognising the value of genotyped_plink_filename
    // tried that, still didn't work. just replace directly with baseName
    output:
    path "${genotyped_plink_file_bed.baseName}.qc.log"
    path "${genotyped_plink_file_bed.baseName}.qc.snplist", emit: genotyped_filtered_snplist_ch
    path "${genotyped_plink_file_bed.baseName}.qc.id", emit: genotyped_filtered_id_ch
    tuple val("${genotyped_plink_file_bed.baseName}.qc"), path("${genotyped_plink_file_bed.baseName}.qc.bim"), path("${genotyped_plink_file_bed.baseName}.qc.bed"),path("${genotyped_plink_file_bed.baseName}.qc.fam"), emit: genotyped_filtered_files_ch

    script:
    def genotyped_plink_filename = genotyped_plink_file_bed.baseName
    // inside script, must always include backslash before any parentheses!
    """
    plink2 \
        --bfile ${genotyped_plink_filename} \
        --maf ${params.qc_maf} \
        --mac ${params.qc_mac} \
        --geno ${params.qc_geno} \
        --hwe ${params.qc_hwe} \
        --mind ${params.qc_mind} \
        --write-snplist \
        --write-samples \
        --no-id-header \
        --out ${genotyped_plink_filename}.qc \
        --make-bed \
        --threads ${task.cpus} \
        --memory ${task.memory.toMega()}
    """
}
