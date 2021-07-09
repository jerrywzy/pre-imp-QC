#!/bin/bash

# fix sites inconsistent with reference that are found in 04VCFcheck

################
## PARAMETERS ##
################
working=/dir/with/scripts # directory to scripts 
overlap=${working}/03overlap # directory to 03overlap
checkvcf=${working}/04VCFcheck
races=( Chinese Malay Indian ) # specified races/names of input files (Chinese.bed, Chinese.bim, Chinese.fam etc)

VCFTOOLS=/dir/to/vcftools/vcftools-vcftools-cb8e254/src/perl
BGZIP=/dir/to/bgzip/

for race in "${races[@]}"
do
  cd ${working}/05fix-mismatch
  mkdir -p "$race"
  cd "$race" 
  
  # HRC
  mkdir -p HRC
  cd HRC
  
  for CHR in {1..22}
  do
    bcftools norm --check-ref ws -f $checkvcf/checkvcf/hs37d5.fa ${overlap}/"$race"/HRC/"$race"_autosomes-updated-chr"$CHR".vcf.gz -o temp.vcf 
        
    $VCFTOOLS/vcf-sort temp.vcf | \
    bgzip -c > "$race"_autosomes-updated-chr"$CHR"-REFfixed.vcf.gz
    
    # run checkVCF.py a second time to ensure no inconsistence reference sites
    python2 $checkvcf/checkvcf/checkVCF.py -r $checkvcf/checkvcf/hs37d5.fa -o VCFcheckedchr"$CHR" "$race"_autosomes-updated-chr"$CHR"-REFfixed.vcf.gz
  done
  
  
  # 1000G
  cd ${working}/05fix-mismatch/"$race"
  mkdir -p 1000G
  cd 1000G
  
  for CHR in {1..22}
  do
    bcftools norm --check-ref ws -f $checkvcf/checkvcf/hs37d5.fa ${overlap}/"$race"/1000G/"$race"_autosomes-updated-chr"$CHR".vcf.gz -o temp.vcf
        
    $VCFTOOLS/vcf-sort temp.vcf | \
    bgzip -c > "$race"_autosomes-updated-chr"$CHR"-REFfixed.vcf.gz
    
    # run checkVCF.py a second time
    python2 $checkvcf/checkvcf/checkVCF.py -r $checkvcf/checkvcf/hs37d5.fa -o VCFcheckedchr"$CHR" "$race"_autosomes-updated-chr"$CHR"-REFfixed.vcf.gz
  done
done
