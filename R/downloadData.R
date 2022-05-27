
downloadData <- function(ids, db = "nucleotide"){
  rseq <- entrez_fetch(db, ids, rettype = "fasta")
  rseq <- unlist(strsplit(rseq, "\n"))

  # Fasta header and the lines at which the sequence starts and stops
  header.lines <- grep(">", rseq)
  seq.pos <- cbind(start = header.lines + 1, stop = c(header.lines[-1] - 1, length(rseq)))
  seq.fasta <- apply(seq.pos, 1, function(x){
    paste0(rseq[ seq(as.numeric(x["start"]), as.numeric(x["stop"])) ], sep = "", collapse = "")
  })
  names(seq.fasta) <- rseq[header.lines]
  return(seq.fasta)
}
