#!/bin/sh
sample_name=$1
datapath=$2
outdir=$3

mkdir -p "$outdir"
source /path/to/config.sh


#### fastqc for fastq files
mkdir -p ${outdir}/fastqc_out
module load FastQC/0.11.8
fastqc -t 8 -o ${outdir}/fastqc_out \
${datapath_aging}/${sample_name}.fastq.gz 

ln -s ${datapath_aging}/${sample_name}.fastq.gz 

module unload FastQC/0.11.8
### Align reads with STAR:
${STAR} --genomeDir /home/abportillo/github_repo/RNA_seq_Bcell/scripts/raw_fastq_bcell/rnaPreprocess/hg38_p14/STAR_hg38_p14_geneCodeGTF_filter \
--readFilesIn ${datapath_aging}/${sample_name}.fastq.gz \
--readFilesCommand zcat \
--runThreadN 8 \
--twopassMode Basic \
--outFilterMultimapNmax 20 \
--alignSJoverhangMin 8 \
--alignSJDBoverhangMin 1 \
--outFilterMismatchNmax 999 \
--outFilterMismatchNoverLmax 0.1 \
--alignIntronMin 20 \
--alignIntronMax 1000000 \
--alignMatesGapMax 1000000 \
--outFilterType BySJout \
--outFilterScoreMinOverLread 0.33 \
--outFilterMatchNminOverLread 0.33 \
--limitSjdbInsertNsj 1200000 \
--outFileNamePrefix ${outdir}/${sample_name}_ \
--outSAMstrandField intronMotif \
--outFilterIntronMotifs None \
--alignSoftClipAtReferenceEnds Yes \
--quantMode TranscriptomeSAM GeneCounts \
--outSAMtype BAM Unsorted \
--outSAMunmapped Within \
--genomeLoad NoSharedMemory \
--chimSegmentMin 15 \
--chimJunctionOverhangMin 15 \
--chimOutType Junctions SeparateSAMold WithinBAM SoftClip \
--chimOutJunctionFormat 1 \
--chimMainSegmentMultNmax 1 \
--outSAMattributes NH HI AS nM NM ch

#--outSAMattrRGline ID:sample1 SM:sample1 PL:ILLUMINA LB:lib1 PU:unit1; not sure lib info. so leave it out
#--outFilterMismatchNmax 10, not use in R1 and R2 because:
# other para. covered this filtering, the default value is unlimited
#--outFilterMultimapNmax 100, for repeat, not use in this round
#--winAnchorMultimapNmax 100, for repeat, not use in this round
# --outSAMmultNmax 25, for allo, not use in this round

