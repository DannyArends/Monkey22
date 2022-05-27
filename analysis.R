#
# The genetics of Monkeypox?
# Dr. Danny Arends, Holiday project 2022
#

setwd("C:/Github/Monkey22/")
source("R/apikey.R")

# Packages for today:
library(msa)
library(RColorBrewer)
library(rentrez)
library(stringdist)
library(seqinr)

# - Todo 0: Where do we get our data from ? (USA, Portugal, Belgium), NCBI
# - Todo 1: Load Genome sequences from fasta and NCBI
# - Todo 2: Create a blast database
# - Todo 3: Load associated proteins from NCBI
# - Todo 4: Create protein model (Levenstein, MSA) -> Consensus
# - Todo 5: tblastn Consensus to the viral genomes DB
# - Todo 6: Genomic layout of the virus
