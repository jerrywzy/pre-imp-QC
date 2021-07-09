#!/bin/bash

# OPTIONAL: this step here is done as Michigan Server QC excludes further SNPs in its QC steps. These SNPs should be excluded in both HRC and 1000G inputs for standardization.

################
## PARAMETERS ##
################
working=/dir/with/scripts # directory to scripts 
overlap=${working}/03overlap # directory to 03overlap
checkvcf=${working}/04VCFcheck
mismatch=${working}/05fix-mismatch
checkserver=${working}/07server-check
mich_files=/dir/with/Mich/excluded/SNP/lists  # dir to typed-only.txt, snps-excluded.txt. Put these files into their own folder named after "$race" in (races)
races=( Chinese Malay Indian ) # specified races/names of input files 

VCFTOOLS=/dir/to/vcftools/vcftools-vcftools-cb8e254/src/perl
BGZIP=/dir/to/bgzip/

# make chr/pos list for exclusion (typed-only.txt and snps-excluded.txt should be downloaded after an initial imputation run on the Michigan Imputation Server)
for race in "${races[@]}"
do
  rm "$race"_to_exclude.txt 
  awk 'NR > 1' ${mich_files}/"$race"/typed-only.txt | awk -F: '{print $1, $2}' >> "$race"_to_exclude.txt   
  awk 'NR > 1' ${mich_files}/"$race"/snps-excluded.txt | awk -F: '{print $1, $2}' >> "$race"_to_exclude.txt    
done

## exclude from both HRC and 1000G VCFs in 05fix-mismatch
for race in "${races[@]}"
do
  cd ${checkserver}/
  mkdir -p "$race"
  cd "$race" 
  # HRC
  mkdir -p HRC
  cd HRC
  
  for CHR in {1..22}
  do
    vcftools --gzvcf ${mismatch}/"$race"/HRC/"$race"_autosomes-updated-chr"$CHR"-REFfixed.vcf.gz --exclude-positions ${checkserver}/"$race"_to_exclude.txt --recode --out "$race"_autosomes-updated-chr"$CHR"-exclusion
    
    $VCFTOOLS/vcf-sort "$race"_autosomes-updated-chr"$CHR"-exclusion.recode.vcf | \
    bgzip > "$race"_autosomes-updated-chr"$CHR"-exclusion.recode.vcf.gz   
  
  done
  
  # 1000G
  cd ${working}/06server-check/"$race"
  mkdir -p 1000G
  cd 1000G
  
  for CHR in {1..22}
  do
  vcftools --gzvcf ${mismatch}/"$race"/1000G/"$race"_autosomes-updated-chr"$CHR"-REFfixed.vcf.gz --exclude-positions ${checkserver}/"$race"_to_exclude.txt --recode --out "$race"_autosomes-updated-chr"$CHR"-exclusion
  
  
  $VCFTOOLS/vcf-sort "$race"_autosomes-updated-chr"$CHR"-exclusion.recode.vcf | \
  bgzip > "$race"_autosomes-updated-chr"$CHR"-exclusion.recode.vcf.gz  
  
  done
done
