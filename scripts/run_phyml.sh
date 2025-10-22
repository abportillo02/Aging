#!/bin/bash
#SBATCH --job-name=phyml_ltr7up_hervh
#SBATCH --output=phyml_ltr7up_hervh.out
#SBATCH --error=phyml_ltr7up_hervh.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=abportillo@coh.org
#SBATCH -n 4
#SBATCH -p all
#SBATCH --mem=4G
#SBATCH --time=12:00:00

source ~/.bashrc
conda activate mamba_abner_BC

phyml -i ltr7up_hervh.phy -d nt