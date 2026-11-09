process markdups {
    container 'glebusasha/bwa_samtools'
    publishDir 'results/markdups'
    tag "$sid"


    input:
    tuple val(sid), path(bamFile)
    
    output:
    tuple val(sid), path("${sid}.markdup.bam")

    script:
    """
    samtools sort -n -u ${sid}.bam \
        | samtools fixmate -m -u - - \
        | samtools sort -u \
        | samtools markdup - ${sid}.markdup.bam

    """
}




