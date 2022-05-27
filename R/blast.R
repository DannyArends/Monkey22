
blast <- function(sequences, tool = "tblastn"){
  tmpfile <- tempfile()
  cat("", file = tmpfile)
  for(name in names(sequences)){
    cat(">",name,"\n", file = tmpfile, append=TRUE)
    cat(gsub("-", "N", sequences[name]), "\n", file = tmpfile, append=TRUE)
  }

  outfmt <- "\"6 qseqid sseqid qstart qend slen sstart send length pident nident mismatch gapopen gaps evalue\""
  res <- system(paste0(tool, " -db ", db, " -outfmt ", outfmt," -query ", tmpfile), intern = TRUE)
  file.remove(tmpfile)

  values <- NA
  if(length(res) > 0){
    values <- unlist(lapply(res, strsplit, "\t"))
  }
  res <- matrix(values, length(res), 14, byrow=TRUE)
  colnames(res) <- c("qseqid","sseqid","qstart","qend","slen","sstart","send","length","pident","nident",
                     "mismatch","gapopen","gaps","evalue")

  res <- data.frame(res)
  res <- res[which(as.numeric(res[, "evalue"]) < 0.01),]

  res[, "sseqid"] <- unlist(lapply(res[, "sseqid"], function(x){
    if(length(grep("|", unlist(strsplit(x, "")), fixed=TRUE)) ==2){
      return(unlist(lapply(strsplit(x, "|", fixed=TRUE), "[", 2)))
    }
    return(x)
  }))
  return(res)
}