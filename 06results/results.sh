#!/bin/bash

# copy final files over if all checks are OK

################
## PARAMETERS ##
################
working=$1 # directory to scripts 
mismatch=${working}/05fix-mismatch # directory to 05fix-mismatch
races=( Chinese Malay Indian ) # specified races/names of input files (Chinese.bed, Chinese.bim, Chinese.fam etc)

for race in "${races[@]}"
do    
  for CHR in {1..22}
  do
    cp ${mismatch}/"$race"/HRC/"$race"_autosomes-updated-chr"$CHR"-REFfixed.vcf.gz .
    cp ${mismatch}/"$race"/1000G/"$race"_autosomes-updated-chr"$CHR"-REFfixed.vcf.gz .
  done
done
  
 