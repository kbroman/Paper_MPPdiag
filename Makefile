R_OPTS=--no-save --no-restore --no-init-file --no-site-file

all: R/diagnostics.html mpp_diag.pdf R/founder_errors.html

mpp_diag.pdf: LaTeX/mpp_diag.tex mpp_diag.bib \
			  Figs/fig1.pdf Figs/fig2.pdf \
			  Figs/fig3.pdf Figs/fig4.pdf \
			  Figs/fig5.pdf Figs/fig6.pdf \
			  Figs/fig7.png Figs/fig8.png \
			  Figs/fig9.pdf \
			  Figs/figS1.pdf Figs/figS2.pdf Figs/figS3.pdf Figs/figS4.pdf Figs/figS9.pdf
	cd $(<D);pdflatex mpp_diag
	cd $(<D);bibtex mpp_diag
	cd $(<D);pdflatex mpp_diag
	cd $(<D);pdflatex mpp_diag
	mv $(<D)/$(@F) $@

LaTeX/mpp_diag.tex: mpp_diag.Rnw
	[ -d LaTeX ] || mkdir LaTeX
	[ -e LaTeX/genetics.bst ] || (cd LaTeX;ln -s ../genetics.bst)
	[ -e LaTeX/mpp_diag.bib ] || (cd LaTeX;ln -s ../mpp_diag.bib)
	[ -e LaTeX/Figs ] || (cd LaTeX;ln -s ../Figs)
	R -e "knitr::knit('$<', '$@')"

R/diagnostics.html: R/diagnostics.Rmd R/func.R Data/svenson.json RawData/intensities.fst
	[ -d R/diag_cache ] || mkdir R/diag_cache
	cd $(<D);R $(R_OPTS) -e "rmarkdown::render('$(<F)')"

R/founder_errors.html: R/founder_errors.Rmd R/diagnostics.html
	cd $(<D);R $(R_OPTS) -e "rmarkdown::render('$(<F)')"

Data/svenson.json: R/prep_files.R Data/svenson_geno19.csv
	R $(R_OPTS) -e "source('$<')"
# also creates Data/svenson_covar.csv

Data/svenson_geno19.csv: R/geneseek2qtl2.R \
						 RawData/Jackson_Lab_Mouse_30jan2013_FinalReport.txt.gz \
						 RawData/Jackson_Lab-Ciciotte_Mouse_05jun2013_FinalReport.txt.gz \
						 Data/MM/MM_allelecodes.csv
	R $(R_OPTS) -e "source('$<')"
# also creates svenson_geno*.csv for other chr
# plus Data/svenson_chrXint.csv and Data/svenson_chrYint.csv

RawData/intensities.fst: R/geneseek2fst.R \
						 RawData/Jackson_Lab_Mouse_30jan2013_FinalReport.txt.gz \
						 RawData/Jackson_Lab-Ciciotte_Mouse_05jun2013_FinalReport.txt.gz
	R $(R_OPTS) -e "source('$<')"

RawData/%_FinalReport.txt: RawData/%_FinalReport.zip
	cd $(<D);unzip $(<F)
	touch $<

Figs/fig%.pdf: R/fig%.R R/diagnostics.html
	[ -d Figs ] || mkdir Figs
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

Figs/fig%.png: R/fig%.R R/diagnostics.html
	[ -d Figs ] || mkdir Figs
	[ -d R/fig_cache ] || mkdir R/fig_cache
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

clean:
	rm Figs/fig?.pdf LaTeX/mpp_diag.tex LaTeX/mpp_diag.bbl  LaTeX/mpp_diag.aux LaTeX/mpp_diag.out LaTeX/mpp_diag.blg LaTeX/mpp_diag.log

zip: mpp_diag.pdf
	cp LaTeX/mpp_diag.tex .
	cd ..; zip mpp_diag.zip \
			   MPPdiag/mpp_diag.Rnw \
			   MPPdiag/mpp_diag.tex \
			   MPPdiag/mpp_diag.bib \
			   MPPdiag/genetics.bst \
			   MPPdiag/Figs/*
	rm mpp_diag.tex
	mv ../mpp_diag.zip .

web: mpp_diag.pdf
	scp mpp_diag.pdf broman-10.biostat.wisc.edu:Website/publications/
