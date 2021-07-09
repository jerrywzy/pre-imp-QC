# -*- coding: utf-8 -*-
"""
Created on Tue Apr  3 14:15:19 2018

@author: LSIWZYJ
"""
import sys
def main(file1, file2):
    f = open(file1,'r')
    f2 = open(file2,'r')
    data = f.read()
    data2 = f2.read()
    lines1 = []
    lines2 = []
    splitdata1 = data.split('\n')
    splitdata2 = data2.split('\n')
    for x in splitdata1:
        lines1.append(x)
        
    for i in splitdata2:
        lines2.append(i)
        
        
    for i in lines1:
        
        if i not in lines2:
            print (i)
            
    
    #for e in eth:
    #    if e == '1':
    #        Chi.append(e)
    #    if e == '2':
    #        Mal.append(e)
    #    if e == '3':
    #        Ind.append(e)
    
    
    
    f.close()
    
main(sys.argv[1], sys.argv[2])