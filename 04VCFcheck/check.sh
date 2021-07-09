#!/bin/bash

# check VCFs with checkVCF.py from Zhan Xiaowei (https://genome.sph.umich.edu/wiki/CheckVCF.py)

################
## PARAMETERS ##
################
working=$1 # directory to scripts 
overlap=${working}/03overlap # directory to 03overlap
checkvcf=${working}/04VCFcheck
races=( Chinese Malay Indian ) # specified races/names of input files (Chinese.bed, Chinese.bim, Chinese.fam etc) 

# download scripts from 
wget http://qbrc.swmed.edu/zhanxw/software/checkVCF/checkVCF-20140116.tar.gz
tar -xvf checkVCF-20140116.tar.gz
mkdir -p checkvcf
mv checkVCF.py README.md example.vcf.gz hs37d5.fa hs37d5.fa.fai checkvcf/

for race in "${races[@]}"
do
  cd ${working}/04VCFcheck
  mkdir -p "$race"
  cd "$race"

  # HRC
  mkdir -p HRC
  cd HRC
  
  for CHR in {1..22}
  do
    python2 $checkvcf/checkvcf/checkVCF.py -r $checkvcf/checkvcf/hs37d5.fa -o VCFcheckedchr"$CHR" ${overlap}/"$race"/HRC/"$race"_autosomes-updated-chr"$CHR".vcf.gz
  done
  
  # 1000G
  cd ${working}/04VCFcheck/"$race"
  mkdir -p 1000G
  cd 1000G
  
  for CHR in {1..22}
  do
    python2 $checkvcf/checkvcf/checkVCF.py -r $checkvcf/checkvcf/hs37d5.fa -o VCFcheckedchr"$CHR" ${overlap}/"$race"/1000G/"$race"_autosomes-updated-chr"$CHR".vcf.gz
  done
done
