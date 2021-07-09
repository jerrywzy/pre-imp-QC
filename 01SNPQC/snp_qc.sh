#!/bin/bash

# run SNP level quality control on input files based on minor allele frequency, deviation from Hardy Weinberg equilibrium and missingness

################
## PARAMETERS ##
################
working=$1 # directory to scripts 
input=${working}/input  # working directory with input files 
races=( Chinese Malay Indian ) # specified races/names of input files (Chinese.bed, Chinese.bim, Chinese.fam etc) 

for race in "${races[@]}"
do
  cd ${working}/01SNPQC
  mkdir -p "$race"
  cd "$race"

  # Extract out a list of autosomal IDs, based on chromosome number, outputs notauto_notmapped.list for excluded SNPs 
  python ${working}/01SNPQC/filterAutosomes.py ${input}/"$race".bim > autosomes.list
    
  # Extract autosomes from .bim file 
  plink --bfile ${input}/"$race".bim --extract autosomes.list --make-bed -out "$race"_autosomes
  
  ##################################
  ## exclude SNPs with maf < 0.05 ##
  ##################################
  plink --bfile "$race"_autosomes --maf 0.05 --make-bed --out "$race"_autosomes_maf
  # use --freq for record keeping
  plink --bfile "$race"_autosomes --freq --out "$race"_autosomes_maf
  awk '{if ($5 < 0.05) print $2}' "$race"_autosomes_maf.frq > maf_low.list
  
  ########################################
  ## exclude SNPs with call rates < 0.95##
  ########################################
  plink --bfile "$race"_autosomes_maf --geno 0.05 --make-bed --out "$race"_autosomes_maf_miss
  # Generate .miss files and list of SNP IDs with call rate <0.95 for record keeping
  plink --bfile "$race"_autosomes_maf --missing --out "$race"_autosomes_maf_miss
  awk '{if ($5 >= 0.05) print $2}' "$race"_autosomes_maf_miss.lmiss > missSNPs.list
  
  #########################################
  ## Filter SNPs that fail HWE at p<10-6 ##
  #########################################
  plink -bfile "$race"_autosomes_maf_miss --hwe 0.000001 --make-bed --out "$race"_autosomes_maf_miss_hwe
  # Generate .hwe files and list of SNP IDs with failing hwe test for record keeping
  plink -bfile "$race"_autosomes_maf_miss --hwe 0.000001 --hardy --out "$race"_autosomes_maf_miss_hwe
  awk '{if ($9 < 0.000001) print $2;}' "$race"_autosomes_maf_miss_hwe.hwe > hwe.list

  # Remove excluded SNPs so far from the initial autosomes list to keep list of remaining autosomes
  grep -v -x -f hwe.list autosomes.list maf_low.list > autosomes_filtered.list
  
done