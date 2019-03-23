# countToFPKM
Convert counts to Fragments Per Kilobase of transcript per Million mapped reads (FPKM).

## Overview
This package provides an easy to use function to convert the read count matrix into FPKM matrix; following the equation in 
![enter image description here][1]
 

The `countToFPKM()` function requires three inputs to return FPKM as numeric matrix normalized by library size and feature length:

 - `counts` A numeric matrix of raw feature counts. 
 - `featureLength` A    numeric vector with feature lengths that can be
   obtained using   
   [biomaRt](https://bioconductor.org/packages/release/bioc/vignettes/biomaRt/inst/doc/biomaRt.html).
 - `meanFragmentLength` A numeric vector with mean fragment lengths,   
   which can be calculate with   
   [Picard](https://broadinstitute.github.io/picard/command-line-overview.html#CollectInsertSizeMetrics)
   using CollectInsertSizeMetrics.

  [1]: https://s0.wp.com/latex.php?latex=%5Ctext%7BFPKM%7D_i%20%3D%20%5Cdfrac%7BX_i%7D%7B%20%5Cleft%28%5Cdfrac%7B%5Cwidetilde%7Bl%7D_i%7D%7B10%5E3%7D%5Cright%29%20%5Cleft%28%20%5Cdfrac%7BN%7D%7B10%5E6%7D%20%5Cright%29%7D%20%3D%20%5Cdfrac%7BX_i%7D%7B%5Cwidetilde%7Bl%7D_i%20N%7D%20%5Ccdot%2010%5E9%20%20&bg=ffffff&fg=000000&s=0
  
## Installation
```r
# install.packages("devtools")
devtools::install_github("AAlhendi1707/countToFPKM")
```
## Usage
```r
library(countToFPKM)

#Import the read count matrix data into R.
counts <- as.matrix(read.csv("RNA-seq.read.counts.csv"))

#Import feature annotations. The lenth of rows should be as the same as in read count matrix.
# Assign feature lenght into a numeric vector.
feature.annotations <- read.table("feature.annotations.hg38.txt", sep="\t", header=TRUE)
featureLength <- feature.annotations$length

#Import sample metrics. The lenth of columns should be as the same as in read count matrix.
# Assign mean fragment length into a numeric vector.
samples.metrics <- read.table("RNA-seq.samples.metrics.txt", sep="\t", header=TRUE)
meanFragmentLength <- samples.metrics$meanFragmentLength

#Return FPKM into a matrix.
foo <- countToFpkm (counts, featureLength, meanFragmentLength)

```

## Citation
See the [doc][ref] for the code and references behind this package.

## Contributing
Please [submit an issue][issues] to report bugs or ask questions.

Please contribute bug fixes or new features with a [pull request][pull] to this
repository.

[issues]: https://github.com/slowkow/ggrepel/issues
[pull]: https://help.github.com/articles/using-pull-requests/
[ref]: https://github.com/AAlhendi1707/countToFPKM/blob/master/doc/countToFPKM-manual.pdf
