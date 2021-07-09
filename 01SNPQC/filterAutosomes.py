#!/usr/bin/python

# Filter SNPid of autosomes from bim file.

import sys
f = open(sys.argv[1],'r')
line =  f.readline()
fw = open("notauto_notmapped.list",'w')     # list of SNPIDs that are not autosomes

while line:
	auto = False
	line = line.split("\t")
	for i in range(1,23):                   # take SNP IDs for chr 1 to 22 only
		if line[0] == str(i):
			print (line[1])
			auto = True             # autosome check
	if not auto:
		fw.write(line[1])               # if not autosome, write to list
		fw.write("\n")	
	line = f.readline()
f.close()
fw.close()

