#!/bin/bash

#==============================================================
#Pipeline GWAS - CHR22 (1000 Genome Project)
#Author Craciun Maria Alexandra
#==============================================================

#!/bin/bash

echo "Starting GWAS Pipeline"

# 1. Create directories
mkdir -p raw_data data_clean results

# 2. Download data (only if missing)
if [ ! -f raw_data/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz ]; then
    echo "Downloading data..."
    wget -P raw_data https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz
else
    echo "Data already exists"
fi

# 3. Convert VCF to PLINK format
plink --vcf raw_data/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz \
      --make-bed \
      --out raw_data/chr22_raw

# 4. Quality Control (QC)
plink --bfile raw_data/chr22_raw \
      --maf 0.05 \
      --hwe 1e-6 \
      --geno 0.05 \
      --make-bed \
      --out data_clean/chr22_clean

# 5. Create Case-Control Phenotypes
awk '{if (NR<=1253) print $1, $2, 1; else print $1, $2, 2}' \
data_clean/chr22_clean.fam > data_clean/pheno_split.txt

# 6. Integrate Phenotypes
plink --bfile data_clean/chr22_clean \
      --pheno data_clean/pheno_split.txt \
      --make-bed \
      --out data_clean/chr22_final

# 7. Association Analysis
plink --bfile data_clean/chr22_final \
      --assoc \
      --allow-no-sex \
      --out results/gwas_result

echo "Pipeline Complete!"
