# fig S1: X chr het vs ave X intensity (to look for sex swaps)

library(broman)
library(qtl2)


# load data with some samples removed
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


# calculate heterozygosit
# use only X markers that showed sex difference in intensity
x_markers <- names(x_pval)[x_pval < 0.05/length(x_pval)]
x_markers <- x_markers[x_markers %in% marker_names(svenson[,"X"])]
phetX <- rowSums(svenson$geno$X[,x_markers] == 2)/rowSums(svenson$geno$X[,x_markers] != 0)


pdf("../Figs/figS1.pdf", width=6.5, height=4, pointsize=10)
par(mar=c(3.1,4.1,1.1,1.1))
grayplot(xint_ave, phetX, pch=21, bg=point_colors[(sex=="M")+1],
         xlab="Average X chr intensity", ylab="Proportion het on X chr",
         mgp.x=c(1.8,0.3,0), mgp.y=c(2.8, 0.3, 0))

# user coordinates of box
u <- par("usr")

# male/female swap: on top + add label
not_male <- which(sex=="M" & xint_ave > 0.45)
segments(xint_ave[not_male], phetX[not_male],
         xint_ave[not_male]-diff(u[1:2])*0.028*2,
         phetX[not_male]+diff(u[3:4])*0.048)
points(xint_ave[not_male], phetX[not_male], pch=21, bg=point_colors[2])
text(xint_ave[not_male]-diff(u[1:2])*0.03*2,
     phetX[not_male]+diff(u[3:4])*0.056, names(not_male), adj=c(1, 0.5))


xo_female <- which(sex=="F" & xint_ave < 0.45)
segments(xint_ave[xo_female], phetX[xo_female],
         xint_ave[xo_female]+diff(u[1:2])*0.028,
         phetX[xo_female]+diff(u[3:4])*0.048)
points(xint_ave[xo_female], phetX[xo_female], pch=21, bg=point_colors[1])
text(xint_ave[xo_female]+diff(u[1:2])*0.032,
     phetX[xo_female]+diff(u[3:4])*0.05, names(xo_female), adj=c(0, 0))

# label samples with >20% missing data
pmis <- n_missing(svenson, "ind", "prop")
himis <- names(pmis)[pmis >= 0.1997]
miscex <- 0.7
miscolor <- "#bf551b"
xd <- diff(u[1:2])*0.01
yd <- diff(u[3:4])*0.02
adj <- setNames(rep(0, length(himis)), himis)
yadj <- setNames(rep(0, length(himis)), himis)
xadj <- setNames(rep(xd, length(himis)), himis)
xadj["M394"] <- -xd
adj["M394"] <- 1
xadj["M412"] <- -xd*0.4
adj["M412"] <- 1
yadj["M412"] <- yd*0.6
yadj["M411"] <- yd*0.8
xadj["M411"] <- xd*0.7
xadj["F326"] <- -xd*0.7
yadj["F326"] <- yd*1.4
xadj["F326"] <- -xd*1.8
adj["F326"] <- 1
for(ind in himis) {
    if(adj[ind]==0.5) text(xint_ave[ind], phetX[ind]+yadj[ind], ind,
                           adj=c(0.5,ifelse(sign(yadj[ind])<0, 1, 0)),
                           cex=miscex, col=miscolor)
    else text(xint_ave[ind]+xadj[ind], phetX[ind]+yadj[ind], ind, adj=adj[ind],
                           cex=miscex, col=miscolor)
}

segments(xint_ave["F326"], phetX["F326"],
         xint_ave["F326"] - xd*1.4,
         phetX["F326"] + yd*1.0)
points(xint_ave["F326"], phetX["F326"], pch=21, bg=point_colors[1])


dev.off()
