# plot of genotype probability differences

library(qtl2)

pr <- readRDS("diag_cache/calc_genoprob.rds")
prcl <- readRDS("diag_cache/calc_genoprob_clean.rds")
pmap <- readRDS("../Data/svenson_v2.rds")$pmap

pdf("../Figs/figS9.pdf", height=9, width=6.5, pointsize=12)
par(mfrow=c(3,1), mar=c(3.6,3.8,2.1,0.6))
ind <- c("M305", "M336", "F404")
for(i in seq_along(ind)) {
    plot_genoprobcomp(pr, prcl, pmap, ind=ind[i], chr="9", threshold=0.25,
                      main=ind[i], xlab="Chr 9 position (Mbp)", ylab="Diplotype",
                      mgp.y=c(1.9, 0.23, 0), mgp.x=c(1.5,0.3,0))

    u <- par("usr")
    text(u[1] - diff(u[1:2])*0.05,
         u[4] + diff(u[3:4])*0.05, LETTERS[i], xpd=TRUE, font=2, cex=1.3)
}
dev.off()
