# countToFPKM
Convert counts to Fragments Per Kilobase of transcript per Million mapped reads (FPKM).

## Overview
This package provides an easy to use function to convert the read count matrix into FPKM matrix:
- `countToFPKM()`

This function requires three arguments to return FPKM as numeric matrix normalized by library size and feature length:

 - `counts` a numeric matrix of raw feature counts. 
 - `featureLength` a numeric vector with feature lengths that can be obtained using   
   [biomaRt](https://bioconductor.org/packages/release/bioc/vignettes/biomaRt/inst/doc/biomaRt.html).
 - `meanFragmentLength` a numeric vector with mean fragment lengths, which can be calculated with   
   [Picard](https://broadinstitute.github.io/picard/command-line-overview.html#CollectInsertSizeMetrics)
   using CollectInsertSizeMetrics.
  
## Installation
```r
## Install
if(!require(devtools)) install.packages("devtools")
devtools::install_github("AAlhendi1707/countToFPKM")
```
## Usage
```r
countToFPKM (counts, featureLength, meanFragmentLength)
```

## Usage example
```r
library(countToFPKM)

#Import the read count matrix data into R.
counts <- as.matrix(read.csv("RNA-seq.read.counts.csv"))

#Import feature annotations. he length of items should be as the same of rows in read count matrix.
# Assign feature lenght into a numeric vector.
feature.annotations <- read.table("feature.annotations.hg38.txt", sep="\t", header=TRUE)
featureLength <- feature.annotations$length

#Import sample metrics. The length of items should be as the same of columns in read count matrix.
# Assign mean fragment length into a numeric vector.
samples.metrics <- read.table("RNA-seq.samples.metrics.txt", sep="\t", header=TRUE)
meanFragmentLength <- samples.metrics$meanFragmentLength

#Return FPKM into a matrix.
foo <- countToFPKM (counts, featureLength, meanFragmentLength)

```
## Citation
See the [doc][ref] for the code and references behind this package.

## Contributing
Please [submit an issue][issues] to report bugs or ask questions.

Please contribute bug fixes or new features with a [pull request][pull] to this
repository.

[issues]: https://github.com/AAlhendi1707/countToFPKM/issues
[pull]: https://help.github.com/articles/using-pull-requests/
[ref]: https://github.com/AAlhendi1707/countToFPKM/blob/master/doc/countToFPKM-manual.pdf
