queryProteins <- function(id = "NC_003310.1"){
  links <- entrez_link(dbfrom = "nuccore", id = id, db = "protein")
  protein.ids <- links$links$nuccore_protein
  if(length(protein.ids) > 0){
    protein.seq <- downloadData(protein.ids, "protein")
    return(protein.seq)
  }
  return(NULL)
}
