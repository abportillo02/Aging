#!/bin/sh
sample_name=$1
datapath=$2
outdir=$3

mkdir -p "$outdir"
source /path/to/config.sh



### check for strand info. of RNAseq data here, if stranded, get separate bam for watson and crick
module load RSeQC/4.0.0
cd ${outdir}
infer_experiment.py \
-r /net/nfs-irwrsrchnas01/labs/dschones/bioresearch/qianhui/hg38_2024/hg38_p14/teAnno_round3/hg38_gencode_exon.bed \
-i ${outdir}/${sample_name}_sorted_nr_sorted.bam

### get bam files on watson and crick strands
${samtools} view -@ 7 -h -f 99 -S -b ${outdir}/${sample_name}_sorted_nr_sorted.bam > ${outdir}/crick1.bam
${samtools} view -@ 7 -h -f 147 -S -b ${outdir}/${sample_name}_sorted_nr_sorted.bam > ${outdir}/crick2.bam
${samtools} view -@ 7 -h -f 83 -S -b ${outdir}/${sample_name}_sorted_nr_sorted.bam > ${outdir}/watson1.bam
${samtools} view -@ 7 -h -f 163 -S -b ${outdir}/${sample_name}_sorted_nr_sorted.bam > ${outdir}/watson2.bam
${samtools} sort -@ 7 -o ${outdir}/${sample_name}_crick1_sorted.bam ${outdir}/crick1.bam
${samtools} sort -@ 7 -o ${outdir}/${sample_name}_crick2_sorted.bam ${outdir}/crick2.bam
${samtools} sort -@ 7 -o ${outdir}/${sample_name}_watson1_sorted.bam ${outdir}/watson1.bam
${samtools} sort -@ 7 -o ${outdir}/${sample_name}_watson2_sorted.bam ${outdir}/watson2.bam

${samtools} merge -f ${outdir}/${sample_name}_crick_merged.bam \
${outdir}/${sample_name}_crick1_sorted.bam ${outdir}/${sample_name}_crick2_sorted.bam
${samtools} merge -f ${outdir}/${sample_name}_watson_merged.bam \
${outdir}/${sample_name}_watson1_sorted.bam ${outdir}/${sample_name}_watson2_sorted.bam

${samtools} index ${outdir}/${sample_name}_crick_merged.bam
${samtools} index ${outdir}/${sample_name}_watson_merged.bam

rm ${outdir}/crick1.bam ${outdir}/crick2.bam ${outdir}/watson1.bam ${outdir}/watson2.bam
rm ${outdir}/${sample_name}_crick1_sorted.bam ${outdir}/${sample_name}_crick2_sorted.bam \
${outdir}/${sample_name}_watson1_sorted.bam ${outdir}/${sample_name}_watson2_sorted.bam