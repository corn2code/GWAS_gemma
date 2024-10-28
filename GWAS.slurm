#!/bin/sh
#SBATCH --array=1-10%10
#SBATCH --ntasks=2
#SBATCH --mem-per-cpu=40G
#SBATCH --job-name=GWAS
#SBATCH --time=25:00:00
#SBATCH --partition=jclarke,batch,guest
#SBATCH --output=output.log/%x_%a.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user= <>

# First we ensure a clean running environment:
module purge

i=${SLURM_ARRAY_TASK_ID}
echo ${i}

a=$(sed -n ${i}p phenotypes.txt)
echo ${a}

ml gemma/0.98

cp WiDiv693.MAF05.vcf.* /scratch/

gemma --bfile /scratch/WiDiv693.MAF05.vcf \
 -p pheno_693_values.GWAS.txt \
 -k ./output/WiDiv693.MAF05.kin.vcf.cXX.txt \
 -c WiDiv693.MAF05.3.pca.txt \
 -n ${i} -lmm 4 \
 -o ${a} \
 -outdir results_NE2020 \

gzip results_NE2020/${a}.assoc.txt
