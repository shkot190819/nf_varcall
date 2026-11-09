process vcfnorm {
    conda 'bioconda::bcftools'
    container 'staphb/bcftools:latest'
    publishDir 'results/varcall'
    tag "$sid"

    input:
    path reference
    path faidx
    tuple val(sid), path(vcf)
        
    output:
    tuple val(sid), path("${sid}.norm.vcf.gz"), path("${sid}.norm.vcf.gz.tbi")

    script:
    """
    bcftools norm -f $reference -m -any -Oz -o ${sid}.norm.vcf.gz $vcf 
    bcftools index -t ${sid}.norm.vcf.gz
    """

}