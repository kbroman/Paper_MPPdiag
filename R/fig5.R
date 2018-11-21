# fig 5: counts of crossovers by mouse

library(broman)
library(qtl2)

# data + counts
svenson <- readRDS("../Data/svenson_v2.rds")
load("diag_cache/maxmarg.RData")
totxo <- rowSums(nxo)

pmis <- n_missing(svenson, "ind", "prop")*100

pdf("../Figs/fig5.pdf", width=6.5, height=3, pointsize=12)
par(mar=c(2.6,4.1,0.6,0.6))

color <- brocolors("sex")
grayplot(totxo[pmis < 19.97], pch=21, bg=color[(svenson$covar$ngen=="11")[pmis < 19.97]+1],
         xlab="Mouse", ylab="Number of crossovers",
         mgp.x=c(1.5,0.3,0), mgp.y=c(2.6,0.3,0))
text(85, 270, "generation 8", col=color[1], adj=0)
text(140, 395, "generation 11", col=color[2], adj=1)
dev.off()
