makeBlastDB <- function(sequences, db = "data/DNAdb.fsa", name = "MonkeyDNA", dbtype = "nucl"){
  cat("", file = db)
  for(header in names(sequences)){
    cat(header, "\n", file = db, append = TRUE)
    cat(sequences[header], "\n", file = db, append = TRUE)
  }
  system(paste0("makeblastdb -in ", db," -parse_seqids -title '", name, "' -dbtype ", dbtype))
  return(db)
}
