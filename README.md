**Introduction
Scripts to carry out quality control on genotypes based on minor allele frequency, deviation from Hardy-Weinberg equilibrium, and missingness before imputation on Michigan and Sanger imputation servers, followed by VCF checks with WilL Rayner's pre-imputation checking scripts and Zhan Xiaowei's checkVCF.py Python script. This pipeline was written to carry out imputation on genotypes from 3 different races, on the 1000 Genome and HRC reference panels.

**Technologies
*Python version: 3.7.6
*PLINK version: 1.90b5.3
*VCFtools version: 0.1.13
*BCFtools version: 1.9 (using htslib 1.9)

**Setup
1. Clone this repository.
2. Place PLINK (.bed, .bim, .fam) files into /input.
2. Edit the section "To be edited by user" in run-pipeline.sh
3. Run run-pipeline.sh with ./run-pipeline.sh.
4. Initial QC-ed files will be located in 06results.
5. (optional) Run initial imputation on Michigan Imputation Server and save typed-only.txt and snps-excluded.txt from the server. Edit the "mich_files" parameter in /07server-check/exclude.sh to direct the script to directory containing the .txt files. Then, run the script with "./exclude.sh". The final files will be located in /07server-check/"$race"/"$panel".
