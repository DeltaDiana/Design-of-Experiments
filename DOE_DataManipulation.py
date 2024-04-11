# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

# standard imports
from scipy import *
from pylab import *
import numpy as np
import scipy.linalg as sl

import csv
from numpy import genfromtxt

# https://www.nasdaqomxnordic.com/indexes/historical_prices?Instrument=SE0000337842
testdata = genfromtxt('OMXS30python-1986-10-31-2015-10-30.csv', delimiter =',')

# remove the head consisting of year, month etc
headdata = testdata[1:, :]


# generate the list of only last trading day
lastdaydata = []
month = 10
for row in headdata:
    #month = str(month)
    if row[1] == month:
        #print(row)
        lastdaydata.append(row)
        if month == 1:
            month = 12
        else:
            month = month-1

# generate list including the return percentage
finaldata = []
i = 1
for row in lastdaydata:
    fvalue = row[3] 
    ivalue = lastdaydata[i][3]
    perreturn = (fvalue - ivalue)/ivalue*100
    arrayreturn = array([perreturn])
    finaldata.append(hstack([row, arrayreturn]))
    i = i+1
    if i == len(lastdaydata):
        break

# sort finaldata into 2 column matrix with A and B
# creating the 2 blocks A: nov - april and B: may - oct
A = []
B = []
j = 1
for row in finaldata:
    if int(row[1]) <= 10 and int(row[1]) >= 5:
        B.append(row)
    else:
        A.append(row)
        
ABlist = vstack([A, B])

#  import to csv       
np.savetxt("ABlist.csv", ABlist, delimiter=",")




