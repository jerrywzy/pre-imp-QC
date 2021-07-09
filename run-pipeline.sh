#!/bin/bash

# run entire pipeline from 01SNPQC to 06results (no 07server-check)

#-------------------------------------------------------------------------------
# TO BE EDITED BY USER
#-------------------------------------------------------------------------------
working=/dir/with/scripts # path to directory containing folders (01SNPQC, 02WRcheck, 03overlap.. 06results, input etc)
races=( Chinese Malay Indian ) # specified races/names of input files 
VCFTOOLS=/dir/to/vcftools/vcftools-vcftools-cb8e254/src/perl

#-------------------------------------------------------------------------------
# Run main scripts
#-------------------------------------------------------------------------------

cd ${working}/01SNPQC

bash snp_qc.sh ${working}

cd ${working}/02WRcheck
bash checkAutosomes.sh ${working}

cd ${working}/03overlap
bash overlap.sh ${working} ${VCFTOOLS}

cd ${working}/04VCFcheck
bash check.sh ${working}

cd ${working}/05fix-mismatch
bash fix-mismatch.sh ${working} ${VCFTOOLS}

cd ${working}/06results
bash results.sh ${working}