# fig S2: histogram of proportion of matching genotypes

library(qtl2)

svenson <- readRDS("../Data/svenson_v1.rds")
pmis <- n_missing(svenson, "ind", "prop")*100

file <- "fig_cache/compare_geno.rds"
if(file.exists(file)) {
    cg <- readRDS(file)
} else {
    cg <- compare_geno(svenson, cores=0)
    saveRDS(cg, file)
}

pdf("../Figs/figS2.pdf", width=6.5, height=8, pointsize=12)
par(mfrow=c(2,1))
par(mar=c(5.1,0.6,2.1, 0.6))
hist(cg[upper.tri(cg)]*100, breaks=seq(0, 100, length=201),
     main="All samples", yaxt="n", ylab="", xlab="Percent matching genotypes")
rug(cg[upper.tri(cg)]*100)
u <- par("usr")
text(u[1]-diff(u[1:2])*0.0,
     u[4]+diff(u[3:4])*0.1,
     "A", font=2, xpd=TRUE, cex=1.4)
box()

cgsub <- cg[pmis < 19.97, pmis < 19.97]
hist(cgsub[upper.tri(cgsub)]*100, breaks=seq(0, 100, length=201),
     main="Samples with < 20% missing genotypes", yaxt="n", ylab="", xlab="Percent matching genotypes")
rug(cgsub[upper.tri(cgsub)]*100)
u <- par("usr")
text(u[1]-diff(u[1:2])*0.0,
     u[4]+diff(u[3:4])*0.1,
     "B", font=2, xpd=TRUE, cex=1.4)
box()


dev.off()
