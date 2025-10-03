#!/bin/sh
sample_name=$1
datapath=$2
outdir=$3

mkdir -p "$outdir"
source /path/to/config.sh


### bam to bedGraph
${bedtools} genomecov -bg -ibam ${outdir}/${sample_name}_crick_merged.bam \
-g /net/nfs-irwrsrchnas01/labs/dschones/bioresearch/qianhui/hg38_2024/hg38_p14/filtered_hg38_p14.chrom.sizes \
> ${outdir}/${sample_name}_crick_readCount.bedGraph

${bedtools} genomecov -bg -ibam ${outdir}/${sample_name}_watson_merged.bam \
-g /net/nfs-irwrsrchnas01/labs/dschones/bioresearch/qianhui/hg38_2024/hg38_p14/filtered_hg38_p14.chrom.sizes \
> ${outdir}/${sample_name}_watson_readCount.bedGraph

### bedGraph to bigwig (read counts)
${wigToBigWig} ${outdir}/${sample_name}_crick_readCount.bedGraph \
/net/nfs-irwrsrchnas01/labs/dschones/bioresearch/qianhui/hg38_2024/hg38_p14/filtered_hg38_p14.chrom.sizes \
${outdir}/${sample_name}_crick_readCount.bw

${wigToBigWig} ${outdir}/${sample_name}_watson_readCount.bedGraph \
/net/nfs-irwrsrchnas01/labs/dschones/bioresearch/qianhui/hg38_2024/hg38_p14/filtered_hg38_p14.chrom.sizes \
${outdir}/${sample_name}_watson_readCount.bw

### bigwig (cpm)
${bamCoverage} -b ${outdir}/${sample_name}_crick_merged.bam \
-o ${outdir}/${sample_name}_crick_cpm.bw --normalizeUsing CPM \
--numberOfProcessors 12 \
--effectiveGenomeSize 2913022398 --binSize 1

${bamCoverage} -b ${outdir}/${sample_name}_watson_merged.bam \
-o ${outdir}/${sample_name}_watson_cpm.bw --normalizeUsing CPM \
--numberOfProcessors 12 \
--effectiveGenomeSize 2913022398 --binSize 1

### bigwig (rpkm)
${bamCoverage} -b ${outdir}/${sample_name}_crick_merged.bam \
-o ${outdir}/${sample_name}_crick_rpkm.bw --normalizeUsing RPKM \
--numberOfProcessors 12 \
--effectiveGenomeSize 2913022398 --binSize 1

${bamCoverage} -b ${outdir}/${sample_name}_watson_merged.bam \
-o ${outdir}/${sample_name}_watson_rpkm.bw --normalizeUsing RPKM \
--numberOfProcessors 12 \
--effectiveGenomeSize 2913022398 --binSize 1