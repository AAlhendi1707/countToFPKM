#' FPKM: Convert counts to Fragments Per Kilobase of transcript per Million mapped reads (FPKM).
#' Written by Ahmed Alhendi (Dr.) (@AAlhendi1707)
#' 
#' The following function returns fragment counts normalized
#' per kilobase of feature length per million mapped fragments
#' (by default using a robust estimate of the library size,
#' as in fpkm).
#' 
#'    Trapnell,C. et al. (2010) Transcript assembly and quantification by RNA-seq reveals unannotated transcripts and isoform switching during cell differentiation. 
#'    Nat. Biotechnol., 28, 511-515.
#'    doi: 10.1038/nbt.1621
#' 
#'    Lior Pachter. Models for transcript quantification from RNA-Seq.
#'    arXiv:1104.3889v2 
#'    
#' @param counts A numeric matrix of raw feature counts.
#' @param featureLength A numeric vector with feature lengths which can be obtained using biomaRt.
#' The length of items should be as the same of rows in read count matrix.
#' @param meanFragmentLength A numeric vector with mean fragment lengths, 
#' which can be calculated using Picard CollectInsertSizeMetrics.
#' The length of items should be as the same of columns in read count matrix.
#' @return A data matrix normalized by library size and feature length.
#'
#' @docType methods
#' @name fpkm
#' @rdname fpkm
#' 
#' @export
NULL
#' @examples
#'
#' library(countToFPKM)
#' file.readcounts <- system.file("extdata", "RNA-seq.read.counts.csv", package="countToFPKM")
#' file.annotations <- system.file("extdata", "Biomart.annotations.hg38.txt", package="countToFPKM")
#' file.sample.metrics <- system.file("extdata", "RNA-seq.samples.metrics.txt", package="countToFPKM")
#' 
#' # Import the read count matrix data into R.
#' counts <- as.matrix(read.csv(file.readcounts))
#' 
#' # Import feature annotations. 
#' # Assign feature lenght into a numeric vector.
#' gene.annotations <- read.table(file.annotations, sep="\t", header=TRUE)
#' featureLength <- gene.annotations$length
#' 
#' # Import sample metrics. 
#' # Assign mean fragment length into a numeric vector.
#' samples.metrics <- read.table(file.sample.metrics, sep="\t", header=TRUE)
#' meanFragmentLength <- samples.metrics$meanFragmentLength
#' 
#' # Return FPKM into a numeric matrix.
#' fpkm_matrix <- fpkm (counts, featureLength, meanFragmentLength)
#' 
#' 
#' @docType methods
#' @name fpkm
#' @rdname fpkm
#' 
#' @export
fpkm <- function(counts, featureLength, meanFragmentLength) {

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
#' fpkmheatmap
#' The following function provide the user with a quick and reliable way to generate 
#' heatmap plot of the highly variable features in RNA-Seq data set.
#' This function returns heatmap of FPKM matrix.
#' (by default using Pearson correlation - 1 to calcualte the distance measurments between features,
#' and Spearman correlation -1 for clustering of samples as in fpkmheatmap).
#' It takes that fpkm numeric matrix from the fpkm() function as input. It then using the var() function 
#' to identify the list of highly variable features to plot using Heatmap function from "ComplexHeatmap" package.
#' (by default using log normalisation log10(FPKM+1) is TRUE. 
#' Note set log to FALSE it returns heatmap of FPKM without log normalisation).
#' 
#' @param fpkm_matrix a data matrix normalized by library size and feature length.
#' @param topvar number of highly variable features to show in heatmap plot.
#' @param showfeaturenames whether to show the name of features in heatmap plot.
#' The default value is \code{TRUE}.
#' @param return_log whether to use log10 transformation of (FPKM+1).
#' The default value is \code{TRUE}.
#' @return a heatmap plot of the highly variable features in RNA-Seq data set.
#' @examples
#'
#' library(countToFPKM)
#' file.readcounts <- system.file("extdata", "RNA-seq.read.counts.csv", package="countToFPKM")
#' file.annotations <- system.file("extdata", "Biomart.annotations.hg38.txt", package="countToFPKM")
#' file.sample.metrics <- system.file("extdata", "RNA-seq.samples.metrics.txt", package="countToFPKM")
#' 
#' # Import the read count matrix data into R.
#' counts <- as.matrix(read.csv(file.readcounts))
#' 
#' # Import feature annotations. 
#' # Assign feature lenght into a numeric vector.
#' gene.annotations <- read.table(file.annotations, sep="\t", header=TRUE)
#' featureLength <- gene.annotations$length
#' 
#' # Import sample metrics. 
#' # Assign mean fragment length into a numeric vector.
#' samples.metrics <- read.table(file.sample.metrics, sep="\t", header=TRUE)
#' meanFragmentLength <- samples.metrics$meanFragmentLength
#' 
#' # Return FPKM into a numeric matrix.
#' fpkm_matrix <- fpkm (counts, featureLength, meanFragmentLength)
#' 
#' # Plot log10(FPKM+1) heatmap of top 30 highly variable features
#' fpkmheatmap(fpkm_matrix, topvar=30, showfeaturenames=TRUE, return_log = TRUE)
#'
#' @docType methods
#' @name fpkmheatmap
#' @rdname fpkmheatmap
#' 
#' @export
fpkmheatmap <- function(fpkm_matrix, topvar=30, showfeaturenames=TRUE, return_log = TRUE) {

if (return_log) {
log10fpkm <- apply((fpkm_matrix+1), 2, log10)
var_genes <- apply(log10fpkm, 1, var)
select_var <- names(sort(var_genes, decreasing=TRUE))[1:topvar]
log10mydf <- log10fpkm[select_var,]

summary1 <- as.data.frame(summary(log10mydf))
summary2 <- data.frame(do.call('rbind', strsplit(as.character(summary1$Freq),':',fixed=TRUE)))

c1 <- round(min(as.numeric(as.character(summary2$X2)), na.rm=TRUE))
c2 <- round(mean(as.numeric(as.character(summary2$X2)), na.rm=TRUE))
c3 <- round(max(as.numeric(as.character(summary2$X2)), na.rm=TRUE))
 if (showfeaturenames){
   Heatmap(log10mydf, name="log10(FPKM+1)", clustering_distance_rows = "pearson", clustering_distance_columns = "spearman", show_row_names = TRUE, col = colorRamp2(c(c1, c2, c3), c("cornflowerblue", "yellow", "red")))
   } else {
   Heatmap(log10mydf, name="log10(FPKM+1)", clustering_distance_rows = "pearson", clustering_distance_columns = "spearman", show_row_names = FALSE, col = colorRamp2(c(c1, c2, c3), c("cornflowerblue", "yellow", "red")))
  }

}else{

var_genes <- apply(fpkm_matrix, 1, var)
select_var <- names(sort(var_genes, decreasing=TRUE))[1:topvar]
mydf <- fpkm_matrix[select_var,]

summary1 <- as.data.frame(summary(mydf))
summary2 <- data.frame(do.call('rbind', strsplit(as.character(summary1$Freq),':',fixed=TRUE)))

c1 <- round(min(as.numeric(as.character(summary2$X2)), na.rm=TRUE))
c2 <- round(mean(as.numeric(as.character(summary2$X2)), na.rm=TRUE))
c3 <- round(max(as.numeric(as.character(summary2$X2)), na.rm=TRUE))

 if (showfeaturenames){
   Heatmap(mydf, name="FPKM", clustering_distance_rows = "pearson", clustering_distance_columns = "spearman", show_row_names = TRUE, col = colorRamp2(c(c1, c2, c3), c("cornflowerblue", "yellow", "red")))
   } else {
   Heatmap(mydf, name="FPKM", clustering_distance_rows = "pearson", clustering_distance_columns = "spearman", show_row_names = FALSE, col = colorRamp2(c(c1, c2, c3), c("cornflowerblue", "yellow", "red")))
  }

 }
}
