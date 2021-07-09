#!/bin/bash

# extract overlap from 1000G and HRC input files after QC with Will Rayner's checking script

################
## PARAMETERS ##
################
working=$1 # directory to scripts 
WRcheck=${working}/02WRcheck # directory to 02WRcheck
races=( Chinese Malay Indian ) # specified races/names of input files (Chinese.bed, Chinese.bim, Chinese.fam etc) 

VCFTOOLS=$2

for race in "${races[@]}"
do
  cd ${working}/03overlap
  mkdir -p "$race"
  cd "$race"
  
  # extract list of IDs from .bim files for HRC  
  for CHR in {1..22}
  do
    cut -f2 $WRcheck/"$race"/HRC/"$race"_autosomes-updated-chr"$CHR".bim >> temp 
  done
  
  sort temp > HRC_sorted_rsID.list
  rm temp
  
  # extract same list from 1000G
  for CHR in {1..22}
  do
    cut -f2 $WRcheck/"$race"/1000G/"$race"_autosomes-updated-chr"$CHR".bim >> temp
  done
  
  sort temp > 1000G_sorted_rsID.list
  rm temp
  
  # find overlap between two ID lists
  comm -12  HRC_sorted_rsID.list 1000G_sorted_rsID.list > overlap_rsID.list
  
  # make vcf files for HRC and 1000G only with the overlapping SNPs
  # HRC
  cd ${working}/03overlap/"$race"
  mkdir -p HRC
  cd HRC
  
  for CHR in {1..22}
  do
    plink --bfile $WRcheck/"$race"/HRC/"$race"_autosomes-updated-chr"$CHR" --extract ${overlap}/"$race"/overlap_rsID.list --recode vcf --out "$race"_autosomes-updated-chr"$CHR"
    
    $VCFTOOLS/vcf-sort "$race"_autosomes-updated-chr"$CHR".vcf | \
    bgzip -c > "$race"_autosomes-updated-chr"$CHR".vcf.gz
  done
  
  # 1000G
  cd ${working}/03overlap/"$race"
  mkdir -p 1000G
  cd 1000G
  
  for CHR in {1..22}
  do
    plink --bfile $WRcheck/"$race"/1000G/"$race"_autosomes-updated-chr"$CHR" --extract ${overlap}/"$race"/overlap_rsID.list --recode vcf --out "$race"_autosomes-updated-chr"$CHR"
    
    $VCFTOOLS/vcf-sort "$race"_autosomes-updated-chr"$CHR".vcf | \
    bgzip -c > "$race"_autosomes-updated-chr"$CHR".vcf.gz
  done
done


