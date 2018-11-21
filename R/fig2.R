# fig 2: ave Y intensitive vs ave X intensity (to look for sex swaps)

library(broman)
library(qtl2)


# load data with *all* samples removed
svenson <- readRDS("../Data/svenson_v1.rds")

# load array intensities for X and Y chr
xint <- read_csv_numer("../Data/svenson_chrXint.csv", transpose=TRUE)
yint <- read_csv_numer("../Data/svenson_chrYint.csv", transpose=TRUE)

# omit samples with high error rates
xint <- xint[ind_ids(svenson),]
yint <- yint[ind_ids(svenson),]

# sex
sex <- substr(rownames(xint), 1, 1)

# load p-values for sex comparisons
load("diag_cache/snps_sex_diff.RData")


# average X and Y intensity using markers showing sex differences
xint_ave <- rowMeans(xint[, x_pval < 0.05/length(x_pval)], na.rm=TRUE)
yint_ave <- rowMeans(yint[, y_pval < 0.05/length(y_pval)], na.rm=TRUE)


# point colors (green for females; purple for males
point_colors <- as.character( brocolors("web")[c("green", "purple")] )


pdf("../Figs/fig2.pdf", width=6.5, height=4, pointsize=10)
par(mar=c(3.1,4.1,1.1,1.1))
grayplot(xint_ave, yint_ave, pch=21, bg=point_colors[(sex=="M")+1],
         xlab="Average X chr intensity", ylab="Average Y chr intensity",
         mgp.x=c(1.8,0.3,0), mgp.y=c(2.8, 0.3, 0))

# user coordinates of box
u <- par("usr")

# male/female swap: on top + add label
not_male <- which(sex=="M" & xint_ave > 0.45)
segments(xint_ave[not_male], yint_ave[not_male],
         xint_ave[not_male]+diff(u[1:2])*0.028,
         yint_ave[not_male]+diff(u[3:4])*0.048)
points(xint_ave[not_male], yint_ave[not_male], pch=21, bg=point_colors[2])
text(xint_ave[not_male]+diff(u[1:2])*0.03,
     yint_ave[not_male]+diff(u[3:4])*0.05, names(not_male), adj=c(0, 0))


xo <- which(sex=="F" & xint_ave < 0.4)
text(xint_ave[xo]+diff(u[1:2])*0.01, yint_ave[xo], names(xo), adj=0)

# label samples with >20% missing data
pmis <- n_missing(svenson, "ind", "prop")
himis <- names(pmis)[pmis >= 0.1997]
miscex <- 0.7
miscolor <- "#bf551b"
xd <- diff(u[1:2])*0.01
yd <- diff(u[3:4])*0.02
adj <- setNames(rep(0, length(himis)), himis)
adj["M392"] <- 0.5
adj["M411"] <- 1
adj["M405"] <- 0.5
yadj <- setNames(rep(0, length(himis)), himis)
yadj["M405"] <- yd*1.5
yadj["M419"] <- -yd
yadj["M411"] <- yd*0.5
yadj["M392"] <- -yd
yadj["M405"] <- yd*0.9
xadj <- setNames(rep(xd, length(himis)), himis)
xadj["M392"] <- xadj["M405"] <- 0
xadj["M411"] <- -xd*0.5
xadj["M419"] <- xd*0.7
xadj["M388"] <- xd*0.85
for(ind in himis) {
    if(adj[ind]==0.5) text(xint_ave[ind], yint_ave[ind]+yadj[ind], ind,
                           adj=c(0.5,ifelse(sign(yadj[ind])<0, 1, 0)),
                           cex=miscex, col=miscolor)
    else text(xint_ave[ind]+xadj[ind], yint_ave[ind]+yadj[ind], ind, adj=adj[ind],
                           cex=miscex, col=miscolor)
}

dev.off()
