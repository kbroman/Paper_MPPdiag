## Cleaning genotype data from Diversity Outbred mice

Files for a paper (in preparation) on genotype diagnostics for
Diversity Outbred mice, focusing on SNPs from MegaMUGA arrays.

- [`mpp_diag.Rnw`](mpp_diag.Rnw) - knitr/LaTeX source
- [`mpp_diag.bib`](mpp_diag.bib) - BibTex references
- [`R/`](R/) - Code for making the figures (plus the basic analyses)

The raw data need to be downloaded separately from FigShare:

- MegaMUGA genotype files for 291 DO mice, <https://doi.org/10.6084/m9.figshare.7359542>
- founder genotypes + marker maps, <https://doi.org/10.6084/m9.figshare.5404750.v2>

R packages needed to compile the paper:

- [R/qtl2](https://kbroman.org/qtl2)
- [fst](http://www.fstpackage.org)
- [R/broman](https://github.com/kbroman/broman)

For [`R/diagnostics.Rmd`](R/diagnostics.Rmd), you will also need:

- [R/qtlcharts](https://kbroman.org/qtlcharts)
- [devtools](https://github.com/hadley/devtools)

---

### License

This manuscript is licensed under [CC BY](https://creativecommons.org/licenses/by/3.0/).

[![CC BY](https://i.creativecommons.org/l/by/3.0/88x31.png)](https://creativecommons.org/licenses/by/3.0/)
