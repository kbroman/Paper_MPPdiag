# fig 9: sample SNP allele intensity plots for select bad markers (plus a good one)
# ...maybe 1 good + 4 bad, colored by observed genotype on left and inferred genotype on right

library(qtl2)
library(fst)
library(broman)
source("func.R")

svenson <- readRDS("../Data/svenson_v2.rds")

# omit individuals with > 20% missing data
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

markers <- c("JAX00279019",
             "backupUNC140137407",
             "UNC12329705",
             "UNC20478577")

for(type in c("pdf", "eps")) {
if(type=="pdf") pdf("../Figs/fig9.pdf", height=8, width=5.5, pointsize=12)
else postscript("../Figs/fig9.eps", height=8, width=5.5, pointsize=12, paper="special", onefile=FALSE, horizontal=FALSE)

par(mfrow=c(4,2), mar=c(3.1,3.1,2.1,1.1))
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
