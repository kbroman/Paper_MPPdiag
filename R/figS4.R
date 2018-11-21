# fig S4-S8: sample SNP allele intensity plots for select bad markers (plus a good one)
# ...maybe 1 good + 4 bad, colored by observed genotype on left and inferred genotype on right

library(qtl2)
library(fst)
library(broman)
source("func.R")

good_markers <- c("UNC15578883", "UNC16359556", "UNC20503012", "UNC25660816", "JAX00318339")

extra_blob  <- c("backupUNC160068099", "UNC120650885", "UNC8957473", "UNC26991894",
                 "UNC111366266")

miscalled <- c("UNC24106408", "UNC28626212", "UNC020133473", "UNC9726629")

horizontal <- c("UNC070931469", "UNC21894871", "UNC29116323", "UNC24745611", "backupUNC160130658")

ugly <- c("JAX00029845", "UNC29332141", "UNC8441383", "UNC13184997")

svenson <- readRDS("../Data/svenson_v2.rds")

# omit individuals with >20% missing data
pmis <- n_missing(svenson, "ind", "prop")*100
svenson <- svenson[pmis < 19.97,]

pmis_mar <- n_missing(svenson, "marker", "proportion")*100
e <- readRDS("diag_cache/errorlod.rds")
e <- do.call("cbind", e)[pmis < 19.97,]
errors_mar <- colSums(e>4)/n_typed(svenson, "marker")*100
load("diag_cache/maxmarg.RData")
m <- m[pmis < 19.97,]
snpg <- predict_snpgeno(svenson, m, cores=0)
snpg <- do.call("cbind", snpg)

# NA -> 0
snpg[is.na(snpg)] <- 0


all_markers <- list(good_markers, extra_blob, horizontal, miscalled, ugly)

for(num in seq_along(all_markers)) {
    markers <- all_markers[[num]]
    nmar <- length(markers)

    pdf(paste0("../Figs/figS", num+3, ".pdf"), height=2*nmar, width=5.5, pointsize=12)

    par(mfrow=c(nmar,2), mar=c(3.1,3.1,2.1,1.1))
    for(i in seq_along(markers)) {
        mar <- markers[i]

        plot_intensities(mar, mgp.x=c(1.4,0.3,0), mgp.y=c(1.8,0.3,0))
        title(main=mar, line=1.05, cex.main=0.9)
        title(main="(observed genotypes)", cex.main=0.8, line=0.25)

        u <- par("usr")
        text(u[1] - diff(u[1:2])*0.13,
             u[4] + diff(u[3:4])*0.12, LETTERS[i*2-1], xpd=TRUE, font=2, cex=1.3)

        plot_intensities(mar, geno=snpg[,mar],
                         mgp.x=c(1.4,0.3,0), mgp.y=c(1.8,0.3,0))
        title(main=mar, line=1.05, cex.main=0.9)
        title(main="(predicted genotypes)", cex.main=0.8, line=0.25)

        u <- par("usr")
        text(u[1] - diff(u[1:2])*0.13,
             u[4] + diff(u[3:4])*0.12, LETTERS[i*2], xpd=TRUE, font=2, cex=1.3)

    }
    dev.off()
}
