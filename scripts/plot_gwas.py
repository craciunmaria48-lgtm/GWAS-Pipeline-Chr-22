# -*- coding: utf-8 -*-
"""
Created on Mon Dec 15 19:14:17 2025

@author: craci
"""

import pandas as pd
import matplotlib.pyplot as plt

path= r'C:\Users\craci\Desktop\Manhattan'
df = pd.read_csv(f'{path}\gwas_result.assoc', sep='\s+')

## Remove rows with P-value NaN
df = df.dropna(subset=['P'])

##Calculate -log10(P)

import numpy as np

df['-log10P'] = -np.log10(df['P'])

## Plot

plt.figure(figsize=(12,6))
plt.scatter(df['BP'], df['-log10P'], c = 'royalblue', s=10, alpha = 0.5)

##Add red line to see the most significant variants

plt.axhline(y=-np.log10(5e-8), color='r', linestyle='--')

plt.title('Manhattan Plot - Chromosome 22 (Simulated)')
plt.xlabel('Base Pairs')
plt.ylabel('-log10(P-value)')
plt.grid(alpha=0.3)