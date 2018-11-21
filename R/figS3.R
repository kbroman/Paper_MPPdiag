# fig S3: a reconstruction genome + genotype probabilities for a single chromosome

library(qtl2)

file <- "fig_cache/f413_chr16_genoprob.rds"
if(file.exists(file)) {
    pr <- readRDS(file)
} else {
    pr <- readRDS("diag_cache/calc_genoprob.rds")
    pr <- pr["F413", "16"]
    saveRDS(pr, file)
}

svenson <- readRDS("../Data/svenson_v2.rds")
load("diag_cache/maxmarg.RData")

pdf("../Figs/figS3.pdf", width=6.5, height=7.8, pointsize=12)
par(mfrow=c(2,1), mar=c(3.1,4.1,2.1,0.6))
plot_onegeno(ph, svenson$pmap, ind="F413", mgp.x=c(1.8,0.3,0),
             ylab="Position (Mbp)")
u <- par("usr")
text(u[1]-diff(u[1:2])*0.115,
     u[4]+diff(u[3:4])*0.05,
     "A", font=2, xpd=TRUE)
legend(8.5, 154, names(CCcolors), pt.bg=CCcolors, pch=22, bg="gray90",
       ncol=4)

plot_genoprob(pr, svenson$pmap, ind="F413", chr="16", threshold=0.25,
              mgp.x=c(1.8,0.3,0), xlab="Chr 16 position (Mbp)", ylab="Diplotype")

u <- par("usr")
text(u[1]-diff(u[1:2])*0.115,
     u[4]+diff(u[3:4])*0.05,
     "B", font=2, xpd=TRUE)

dev.off()
