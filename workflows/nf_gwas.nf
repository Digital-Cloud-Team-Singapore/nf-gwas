if(params.outdir == "default" || params.outdir == null) {
    params.pubDir = "output/${params.project}"
} else {
    params.pubDir = params.outdir
}

include { SINGLE_VARIANT_TESTS } from './single_variant_tests'
include { GENE_BASED_TESTS     } from './gene_based_tests'


workflow NF_GWAS {

    def ANSI_RESET = "\u001B[0m"
    def ANSI_YELLOW = "\u001B[33m"

    def genotypes_association = params.genotypes_association
    if(params.genotypes_imputed){
        genotypes_association = params.genotypes_imputed
        println ANSI_YELLOW + "WARN: Option genotypes_imputed is deprecated. Please use genotypes_association instead." + ANSI_RESET
    } 

    //check deprecated option
    def genotypes_association_format = params.genotypes_association_format
    if(params.genotypes_imputed_format){
        genotypes_association_format = params.genotypes_imputed_format
        println ANSI_YELLOW + "WARN: Option genotypes_imputed_format is deprecated. Please use genotypes_association_format instead." + ANSI_RESET
    } 

    // def genotypes_prediction = params.genotypes_prediction
    def genotypes_prediction_bed = params.genotypes_prediction_bed
    def genotypes_prediction_bim = params.genotypes_prediction_bim
    def genotypes_prediction_fam = params.genotypes_prediction_fam
    if(params.genotypes_array){
        println ANSI_RESET +  "ERROR: Option genotypes_array is deprecated. Please use genotypes_prediction instead." + ANSI_RESET
        exit 1
    }

    def association_build = params.association_build
    if(params.genotypes_build){
        association_build = params.genotypes_build
        println ANSI_YELLOW +  "WARN: Option genotypes_build is deprecated. Please use association_build instead." + ANSI_RESET
    }

    //validate input parameters
    WorkflowMain.validate(params,genotypes_association_format)
    
    def run_gene_tests = params.regenie_run_gene_based_tests
    def run_interaction_tests = params.regenie_run_interaction_tests
    def skip_predictions = params.regenie_skip_predictions

    imputed_files_ch = channel.fromPath(genotypes_association, checkIfExists: true)
    phenotypes_file = file(params.phenotypes_filename, checkIfExists: true)

    covariates_file = []
    if(params.covariates_filename) {
        
        covariates_file = file(params.covariates_filename, checkIfExists: true)

    }

    // genotyped_plink_ch = Channel.empty()
    genotyped_plink_file_bed = file("/")
    genotyped_plink_file_bim = file("/")
    genotyped_plink_file_fam = file("/")
    if(!skip_predictions) {
        // problematic, assumes input has {} that needs to be expanded + * globbed
        // this is most likely incompatible with AWS S3
        // esp since it tries to verify the existence of these files
        // genotyped_plink_ch = Channel.fromFilePairs(genotypes_prediction, size: 3, checkIfExists: true)
        // now we only expect a .bed file path as genotypes_prediction
        // genotyped_plink_ch = Channel.fromPath(genotypes_prediction, checkIfExists: true)
        genotyped_plink_file_bed = file(genotypes_prediction_bed, checkIfExists: true)
        genotyped_plink_file_bim = file(genotypes_prediction_bim, checkIfExists: true)
        genotyped_plink_file_fam = file(genotypes_prediction_fam, checkIfExists: true)
        // TODO: convert these into channel.fromPath() maybe it will fix hanging issue

    }

    //Optional condition-list file
    condition_list_file = Channel.empty()
    if (params.regenie_condition_list) {
            condition_list_file = Channel.fromPath(params.regenie_condition_list)
    } 

    if (!run_gene_tests) {
   
        SINGLE_VARIANT_TESTS(
            imputed_files_ch,
            phenotypes_file,
            covariates_file,
            genotyped_plink_file_bed,
            genotyped_plink_file_bim,
            genotyped_plink_file_fam,
            association_build,
            genotypes_association_format,
            condition_list_file,
            skip_predictions,
            run_interaction_tests
        )

    } else {
        GENE_BASED_TESTS(
            imputed_files_ch,
            phenotypes_file,
            covariates_file,
            genotyped_plink_file_bed,
            genotyped_plink_file_bim,
            genotyped_plink_file_fam,
            genotypes_association,
            association_build,
            genotypes_association_format,
            condition_list_file,
            skip_predictions,
            run_interaction_tests
        )
    
    }
}

workflow.onComplete {
    println "Pipeline completed at: $workflow.complete"
    println "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}

