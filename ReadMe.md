## Cleaning genotype data from Diversity Outbred mice

[![DOI](https://zenodo.org/badge/158576258.svg)](https://zenodo.org/badge/latestdoi/158576258)

Files for the paper:

> Broman KW, Gatti DM, Svenson KL, Sen &#346;, Churchill GA (2019)
> Cleaning genotype data from Diversity Outbred mice.
> [G3 (Bethesda)](https://academic.oup.com/g3journal) 9:1571-1579
> [![PubMed](https://kbroman.org/icons16/pubmed-icon.png)](https://www.ncbi.nlm.nih.gov/pubmed/30877082)
> [![pdf](https://kbroman.org/icons16/pdf-icon.png)](https://academic.oup.com/g3journal/article-pdf/9/5/1571/37178363/g3journal1571.pdf)
> [![supporting info](https://kbroman.org/icons16/supp-icon.png)](https://doi.org/10.25387/g3.7848395)
> [![GitHub](https://kbroman.org/icons16/github-icon.png)](https://github.com/kbroman/Paper_MPPdiag)
> [![doi](https://kbroman.org/icons16/doi-icon.png)](https://doi.org/10.1534/g3.119.400165)


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

Current PDF of the paper at <https://www.biostat.wisc.edu/~kbroman/publications/mpp_diag.pdf>

---

### License

This manuscript is licensed under [CC BY](https://creativecommons.org/licenses/by/3.0/).

[![CC BY](https://i.creativecommons.org/l/by/3.0/88x31.png)](https://creativecommons.org/licenses/by/3.0/)
