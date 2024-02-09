include { QC_FILTER_GENOTYPED } from '../modules/local/qc_filter_genotyped' 

workflow QUALITY_CONTROL {

    take:
    genotyped_plink_file_bed
    genotyped_plink_file_bim
    genotyped_plink_file_fam
    
    main:

    QC_FILTER_GENOTYPED (
        genotyped_plink_file_bed,
        genotyped_plink_file_bim,
        genotyped_plink_file_fam
    )

    emit: 
    genotyped_filtered_files_ch = QC_FILTER_GENOTYPED.out.genotyped_filtered_files_ch
    genotyped_filtered_snplist_ch = QC_FILTER_GENOTYPED.out.genotyped_filtered_snplist_ch
    genotyped_filtered_id_ch = QC_FILTER_GENOTYPED.out.genotyped_filtered_id_ch
}


