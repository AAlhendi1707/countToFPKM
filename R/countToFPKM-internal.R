#' Convert counts to Fragments Per Kilobase of transcript per Million mapped reads (FPKM).
#' Written by Ahmed Alhendi (Dr.) (@AAlhendi1707)
#' 
#' Convert a numeric matrix of features (rows) and conditions (columns) with
#' raw feature counts to Fragments Per Kilobase of transcript per Million mapped reads.
#' 
#'    Trapnell,C. et al. (2010) Transcript assembly and quantification by RNA-seq reveals unannotated transcripts and isoform switching during cell differentiation. 
#'    Nat. Biotechnol., 28, 511–515.
#'    doi: 10.1038/nbt.1621
#' 
#'    Lior Pachter. Models for transcript quantification from RNA-Seq.
#'    arXiv:1104.3889v2 
#'    
#'    
#' @param counts A numeric matrix of raw feature counts.
#' @param featureLength A numeric vector with feature lengths.
#' @param meanFragmentLength A numeric vector with mean fragment lengths.
#' @return fpkm A numeric matrix normalized by library size and feature length.
#' 

countToFPKM <- function(counts, featureLength, meanFragmentLength) {
  
  # Ensure valid arguments.
  stopifnot(length(featureLength) == nrow(counts))
  stopifnot(length(meanFragmentLength) == ncol(counts))
  
  # Compute effective lengths of features in each library.
  effLen <- do.call(cbind, lapply(1:ncol(counts), function(i) {
    featureLength - meanFragmentLength[i] + 1
  }))
  
  idx <- apply(effLen, 1, function(x) min(x) > 1)
  counts <- counts[idx,]
  effLen <- effLen[idx,]
  featureLength <- featureLength[idx]
  
  
  # Process one column at a time for fpkm calculation
  fpkm <- do.call(cbind, lapply(1:ncol(counts), function(i) {
    N <- sum(counts[,i])
    exp( log(counts[,i]) + log(1e9) - log(effLen[,i]) - log(N) )
  }))
  
  
  # Copy the row and column names from the original matrix.
  colnames(fpkm) <- colnames(counts)
  rownames(fpkm) <- rownames(counts)
  return(fpkm)
}
