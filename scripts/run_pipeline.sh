#!/bin/bash

#==============================================================
#Pipeline GWAS - CHR22 (1000 Genome Project)
#Author Craciun Maria Alexandra
#==============================================================

# 0. Create directory structure

mkdir -p raw_data data_clean results

echo "Starting GWAS Pipeline"

# 1. Convert VCF to PLINK Binary Format

plink --vcf raw_data/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz \
      --make-bed \
      --out raw_data/chr22_raw

# 2. Quality Control (QC)

plink --bfile raw_data/chr22_raw \
      --maf 0.05 \ 
      --hwe 1e-6 \
      --geno 0.05 \
      --make-bed \
      --out data_clean/chr22_clean

#3 Create Case Control

awk '{if (NR<=1253) print $1, $2, 1; else print $1, $2, 2}' data_clean/chr22_clean.fam > data_clean/pheno_split.txt

#4 Integrate Phenotypes

plink --bfile data_clean/chr22_clean \
      --pheno data_clean/pheno_split.txt \
      --make-bed \
      --out data_clean/chr22_final

#Association Analysis
#allow no sex because there is missing data for this column and the associations won't take place
plink --bfile data_clean/chr22_final \
      --assoc \
      --allow-no-sex \
      --out results/gwas_result

echo "Pipline Complete!"

