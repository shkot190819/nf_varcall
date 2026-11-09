#!/usr/bin/env nextflow
include { refindex } from './processes/refindex.nf'
include { qcontrol } from './processes/qcontrol.nf'
include { align } from './processes/align.nf'
include { faindex } from './processes/faindex.nf'
include { markdups } from './processes/markdups.nf'
include { bamindex } from './processes/bamindex.nf'
include { varcall } from './processes/varcall.nf'
include { vcfnorm } from './processes/vcfnorm.nf'
include { flagstat } from './processes/flagstat.nf'
include { bcfstats } from './processes/bcfstats.nf'
include { report } from './processes/report.nf'


workflow {
    reads = channel.fromFilePairs(params.reads)
    reference = channel.fromPath(params.reference).collect()
    refindex(reference)
    qcontrol(reads)
    align(reference, qcontrol.out[0], refindex.out)
    faindex(reference)
    markdups(align.out)
    bamindex(markdups.out)
    varcall(reference, markdups.out.join(bamindex.out), faindex.out)
    vcfnorm(reference, faindex.out, varcall.out)
    flagstat(align.out)
    bcfstats(varcall.out)
    report(
        qcontrol.out.json
        .mix(flagstat.out.map { it -> it[1] }.view())
        .mix(bcfstats.out.map { it -> it[1] }.view())
        .collect()
        .view()
        )
    
}
