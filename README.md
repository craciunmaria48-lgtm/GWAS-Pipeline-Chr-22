#  GWAS Pipeline - Chromosome 22

This repository provides a complete Genome-Wide Association Study (GWAS) pipeline using PLINK.

The pipeline:

Converts raw VCF genotype data into PLINK format
Performs quality control (QC) filtering
Generates case/control phenotypes
Runs association analysis

Designed for Chromosome 22 data from the 1000 Genomes Project, but easily adaptable to other datasets.

Project Structure

.
├── results/     
├── scripts/    
└── README.md

Requirements
PLINK (v1.9+ recommended)
Linux / macOS / WSL
Bash shell
Core utilities (awk, mkdir)

Clone the repository:

git clone https://github.com/craciunmaria48-lgtm/GWAS-Pipeline-Chr-22/

cd GWAS-Pipeline-Chr-22

Run the pipeline:
bash scripts/run_pipeline.sh

Pipeline Workflow
1. Create Directory Structure
mkdir -p raw_data data_clean results
2. Download input data
   wget -P raw_data https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz
3. Convert VCF → PLINK Binary
plink --vcf raw_data/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz \
      --make-bed \
      --out raw_data/chr22_raw
4. Quality Control (QC)
Filters applied:
MAF ≥ 0.05
HWE p ≥ 1e-6
Missingness ≤ 5%
plink --bfile raw_data/chr22_raw \
      --maf 0.05 \
      --hwe 1e-6 \
      --geno 0.05 \
      --make-bed \
      --out data_clean/chr22_clean
5. Generate Case-Control Phenotypes
awk '{if (NR<=1253) print $1, $2, 1; else print $1, $2, 2}' \
data_clean/chr22_clean.fam > data_clean/pheno_split.txt
6. Integrate Phenotypes
plink --bfile data_clean/chr22_clean \
      --pheno data_clean/pheno_split.txt \
      --make-bed \
      --out data_clean/chr22_final
7. Association Analysis
plink --bfile data_clean/chr22_final \
      --assoc \
      --allow-no-sex \
      --out results/gwas_result

Output
Results are saved in the results/ directory:
gwas_result.assoc → SNP association results


Important Notes
Phenotypes are synthetically generated (for demonstration only)

Acknowledgments
1000 Genomes Project
PLINK developers
