#!/bin/bash

# Run Will Rayner's PLINK checking script on input data to check script against 1000G/HRC panels before imputation

################
## PARAMETERS ##
################
working=$1 # directory to scripts 
snpqc=${working}/01SNPQC # directory to 01SNPQC
WRcheck=${working}/02WRcheck # directory to 02WRcheck
races=( Chinese Malay Indian ) # specified races/names of input files (Chinese.bed, Chinese.bim, Chinese.fam etc) 
panels=( 1000G HRC ) # panels to run Will Rayner's checking script on

### downloads for WR checking script
wget https://www.well.ox.ac.uk/~wrayner/tools/HRC-1000G-check-bim-v4.2.11.zip
unzip HRC-1000G-check-bim-v4.2.11.zip

wget ftp://ngs.sanger.ac.uk/production/hrc/HRC.r1-1/HRC.r1-1.GRCh37.wgs.mac5.sites.tab.gz
gunzip HRC.r1-1.GRCh37.wgs.mac5.sites.tab.gz

wget https://www.well.ox.ac.uk/~wrayner/tools/1000GP_Phase3_combined.legend.gz
unzip 1000GP_Phase3_combined.legend.gz
      
for race in "${races[@]}"
do
  cd ${working}/02WRcheck
  mkdir -p "$race"
  cd "$race"
  
  for panel in "${panels[@]}"
  do
    cd ${working}/02WRcheck/"$race"
    mkdir -p "$panel"
    cd "$panel"

    # Copy Autosomes plink files from SNPQC directory
    plink --bfile ${snpqc}/"$race"/"$race"_autosomes_maf_miss_hwe \
    --make-bed -out "$race"_autosomes
    
    # Generate .frq file from plink files
    plink --bfile "$race"_autosomes \
    --freq -out "$race"_autosomes
    
    if [[ "$panel" = "HRC" ]]; then
      # Run WR script for HRC    
      perl ${WRcheck}/HRC-1000G-check-bim.pl -b "$race"_autosomes.bim \
      -f "$race"_autosomes.frq \
      -r ${WRcheck}/HRC.r1-1.GRCh37.wgs.mac5.sites.tab -h
    
    elif [[ "$panel" = "1000G" ]]; then
      # Run WR script to check data against EAS(Chinese, Malay) or SAS (Indian) population in 1000GP
      if [[ "$race" = "Indian" ]]; then
        perl ${WRcheck}/HRC-1000G-check-bim.pl -b "$race"_autosomes.bim -f "$race"_autosomes.frq -r ${WRcheck}/1000GP_Phase3_combined.legend -g -p SAS
      else
        perl ${WRcheck}/HRC-1000G-check-bim.pl -b "$race"_autosomes.bim -f "$race"_autosomes.frq -r ${WRcheck}/1000GP_Phase3_combined.legend -g -p EAS
      fi
      
    # Run plink script
    chmod 770 Run-plink.sh 
    ./Run-plink.sh
    
    fi
  done
done