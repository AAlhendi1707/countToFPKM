\name{countToFPKM-package}
\alias{countToFPKM}
\docType{package}
\title{
\packageTitle{countToFPKM}
}
\description{
\packageDescription{countToFPKM}
}
\details{

The DESCRIPTION file:
\packageDESCRIPTION{countToFPKM}
This package is to convert a numeric matrix of features (rows) and conditions (columns) with raw feature counts of RNA-seq data to fragments per kilobase of transcript per million mapped reads.
@param counts A numeric matrix of raw feature counts i.e. fragments assigned to each gene.
@param featureLength A numeric vector with feature lengths.
@param meanFragmentLength A numeric vector with mean fragment lengths.
@return fpkm A numeric matrix normalized by library size and feature length.
}
\author{
\packageAuthor{countToFPKM}
Maintainer: \packageMaintainer{countToFPKM}
}
\references{
Trapnell,C. et al. (2010) Transcript assembly and quantification by RNA-seq reveals unannotated transcripts and isoform switching during cell differentiation. Nat. Biotechnol., 28, 511–515. doi: 10.1038/nbt.1621

Lior Pachter. Models for transcript quantification from RNA-Seq.
arXiv:1104.3889v2 
}
\keyword{ FPKM }

\examples{
foo <- countToFpkm (counts, featureLength, meanFragmentLength)
}
