#!/bin/sh
sample_name=$1
datapath=$2
outdir=$3

mkdir -p "$outdir"
source /path/to/config.sh



### sort by coordinates, Remove duplicates and sort

${samtools} sort -@ 8 -O bam -o ${outdir}/${sample_name}_sorted.bam ${outdir}/${sample_name}_Aligned.out.bam
${samtools} index ${outdir}/${sample_name}_sorted.bam
rm ${outdir}/${sample_name}_Aligned.out.bam

### sort by coordinates, Remove duplicates and sort
# module load picard/2.21.1
picard MarkDuplicates \\
    I=${outdir}/${sample_name}_sorted.bam \\
    O=${outdir}/${sample_name}_nr_sorted.bam  \\
    M=${outdir}/${sample_name}_picardStats.txt \\
    REMOVE_DUPLICATES=true 
   
picard AddOrReplaceReadGroups \
    -I ${outdir}/${sample_name}_sorted.bam \
    -O ${outdir}/${sample_name}_rg_sorted.bam \
    --RGID ${sample_name} \
    --RGLB default_lib \
    --RGPL ILLUMINA \
    --RGPU unknown \
    --RGSM ${sample_name}\
    --SORT_ORDER coordinate

 ${java} -Djava.io.tmpdir=/home/abportillo/github_repo/RNA_seq_Bcell/scripts/raw_fastq_bcell/rnaPreprocess/temp \
  -jar /home/abportillo/.conda/envs/mamba_abner_BC/share/picard-3.3.0-0/picard.jar MarkDuplicates \
  --INPUT ${outdir}/${sample_name}_rg_sorted.bam --OUTPUT ${outdir}/${sample_name}_nr_sorted.bam \
 --REMOVE_DUPLICATES true --READ_NAME_REGEX null --METRICS_FILE ${outdir}/${sample_name}_picardStats.txt

${samtools} sort -@ 8 -O bam -o ${outdir}/${sample_name}_sorted_nr_sorted.bam ${outdir}/${sample_name}_nr_sorted.bam
${samtools} index -@ 8 ${outdir}/${sample_name}_sorted_nr_sorted.bam