# fig 3: array intensities (gray for bulk of them; highlight a few)

library(qtl2)
library(broman)
library(fst)

color <- c("gray72", "slateblue", "violetred", brocolors("web")["orange"])

# load cross
svenson <- readRDS("../Data/svenson_v1.rds")
pmis <- n_missing(svenson, "ind", "prop")*100

# density estimates of log10(array intensity + 1)
file <- "fig_cache/int_densities.RData"
if(file.exists(file)) {
    load(file)
    stopifnot(all(colnames(d) == names(pmis)))
} else {
    int <- fst::read.fst("../RawData/intensities.fst")
    int <- int[seq(1, nrow(int), by=2),-(1:2)] + int[-seq(1, nrow(int), by=2),-(1:2)]
    int <- int[,ind_ids(svenson)]
    int <- log10(int + 1)

    x <- seq(0, 1, len=201)
    d <- apply(int, 2, function(a) density(a[!is.na(a)], from=0, to=1, n=201, bw=0.01)$y)

    qu <- t(apply(int, 2, quantile, c(0.01, 0.99), na.rm=TRUE))

    save(x, d, qu, file=file)
}

for(type in c("pdf", "eps")) {

if(type=="pdf") pdf("../Figs/fig3.pdf", width=6.5, height=2.7, pointsize=9)
else postscript("../Figs/fig3.eps", width=6.5, height=2.7, pointsize=10, paper="special", horizontal=FALSE, onefile=FALSE)

layout(cbind(1,2), width=c(1.5,1))

# A: density estimates
par(mar=c(3.1, 2.1, 1.6, 1.1))
ymx <- max(d, na.rm=TRUE)*1.05
grayplot(x, d[,1], type="n", ylim=c(0, ymx), xlim=c(0,0.92),
         xaxs="i", yaxs="i",
         mgp.x=c(1.8, 0.3, 0), mgp.y=c(0,0.3,0),
         xlab="log10(array intensity + 1)", ylab="")
for(i in 1:ncol(d)) lines(x, d[,i], col=color[1])


for(mouse in names(pmis)[pmis > 2 & pmis < 8.9]) {
    lines(x, d[,mouse], col=color[2])
}

for(mouse in names(pmis)[pmis >= 8.9 & pmis < 19.97]) {
    lines(x, d[,mouse], col=color[3])
}

for(mouse in names(pmis)[pmis >= 19.97]) {
    lines(x, d[,mouse], col=color[4])
}

box()

u <- par("usr")
text(u[1]-diff(u[1:2])*0.065,
     u[4]+diff(u[3:4])*0.07,
     "A", font=2, xpd=TRUE, cex=1.4)

# B: 1st percentile vs 99th percentile
par(mar=c(3.1, 3.1, 1.6, 0.6))
pointcolors <- rep(color[1], length(pmis))
pointcolors[pmis > 2 & pmis < 8.9] <- color[2]
pointcolors[pmis >= 8.9 & pmis < 19.97] <- color[3]
pointcolors[pmis >= 19.97] <- color[4]
grayplot(qu[,1], qu[,2], pch=21, bg=pointcolors,
         mgp.x=c(1.8, 0.3, 0), mgp.y=c(1.8, 0.3, 0), cex=0.8,
         xlab="1st %ile of log10(intensity + 1)", ylab="99th %ile of log10(intensity + 1)")

# label 3 mice
u <- par("usr")
text(qu["F326", 1]+diff(u[1:2])*0.015,
     qu["F326", 2]+diff(u[3:4])*0.015, "F326",
     adj=c(0,0), col="#bf551b", cex=0.7)

text(u[1]-diff(u[1:2])*0.18,
     u[4]+diff(u[3:4])*0.07,
     "B", font=2, xpd=TRUE, cex=1.4)

dev.off()
}
