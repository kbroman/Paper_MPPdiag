# fig 8: genotype frequencies by marker (split by MAF in founders)


library(qtl2)
library(broman)

load("diag_cache/snp_freq_marker.RData")
svenson <- readRDS("../Data/svenson_v2.rds")
fg <- do.call("cbind", svenson$founder_geno[1:19])
fg <- fg[,colSums(fg==0)==0]
fgn <- colSums(fg==3)

for(type in c("png", "jpg")) {
if(type=="png") png("../Figs/fig8.png", width=6.5, height=5.5, pointsize=12, units="in", res=300)
else jpeg("../Figs/fig8.jpg", width=6.5, height=5.5, pointsize=12, units="in", res=300)
par(mfrow=c(2,2), mar=c(0.6, 0.6, 2.1, 0.6))
for(i in 1:4) {
    triplot(c("AA", "AB", "BB"))
    title(main=paste0("MAF = ", i, "/8"), line=0.2)
    mtext(side=3, adj=0, font=2, LETTERS[i], line=0.2)
    z <- gf_mar[fgn==i,]
    z <- z[rowSums(is.na(z)) < 3,]
    tripoints(z, pch=21, bg="gray80", cex=0.6)
    tripoints(c((1-i/8)^2, 2*i/8*(1-i/8), (i/8)^2), pch=21, bg="violetred")
}
dev.off()
}
