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
sourceIDs <- read.table("data/monkeypox_annotation.txt", sep = "\t", header=TRUE, row.names = 1)

# - Todo 1: Load Genome sequences from fasta and NCBI
source("R/downloadData.R")
ncbi.seq <- downloadData(rownames(sourceIDs))

# - Todo 2: Create a blast database
source("R/blastDB.R")
db <- makeBlastDB(ncbi.seq)

# - Todo 3: Load associated proteins from NCBI
source("R/queryProteins.R")

proteins <- c()
for(id in rownames(sourceIDs)){
  proteins <- c(proteins, queryProteins(id))
  Sys.sleep(0.5)
}

# - Todo 4: Create protein model (Levenstein, MSA) -> Consensus
myconseni <- c()
for(x in 1:5){
  similar <- names(proteins[which(stringdist(proteins[x], proteins, method = "lv") < 15)])
  mymsa <- msa(AAStringSet(proteins[similar]))
  myconsensus <- msaConsensusSequence(mymsa)
  myconseni <- c(myconseni, myconsensus)
}
names(myconseni) <- paste0("consensus_", 1:5)

# - Todo 5: tblastn Consensus to the viral genomes DB
source("R/blast.R")
blast.res <- blast(myconseni)
positions <- c(as.numeric(blast.res[, "sstart"]), as.numeric(blast.res[, "send"]))


# - Todo 6: Genomic layout of the virus

colz <- brewer.pal(5, "Set2")

op <- par(mar = c(10, 2, 0, 0))
plot(c(0, nrow(sourceIDs)), y = c(min(positions), 7500), t = 'n', xaxt = 'n', xlab = "")
for(name in rownames(sourceIDs)){
  ii <- which(blast.res[, "sseqid"] == name)
  for(i in ii){
    ys <- blast.res[i, "sstart"]
    ye <- blast.res[i, "send"]
    xpos <- which(rownames(sourceIDs) == name)
    
    q <- blast.res[i, "qseqid"]
    n <- unlist(lapply(strsplit(q, "_"), "[", 2))

    points(c(xpos, xpos), c(ys,ye), t = 'p', pch = 19, col = colz[as.numeric(n)])
    points(c(xpos, xpos), c(ys,ye), t = 'l', col = colz[as.numeric(n)])
  }
}

display.names <- paste0(sourceIDs[, "Country"], " ", sourceIDs[, "Year"], " ", sourceIDs[, "Sub.Type"])
axis(1, at = 1:nrow(sourceIDs), display.names, las=2, cex.axis= 0.7)








