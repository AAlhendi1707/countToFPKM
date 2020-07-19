.onAttach <- function(libname, pkgname) {
 packageStartupMessage(rule())
    packageStartupMessage(
      "To cite the R package 'countToFPKM' in publications use:\n",
      "Alhendi, A.S.N. (2019). countToFPKM: Convert Counts to Fragments per Kilobase of Transcript per Million (FPKM). R package version 1.0.0.\n",
      "https://CRAN.R-project.org/package=countToFPKM\n"
    )
 packageStartupMessage(rule())
}
