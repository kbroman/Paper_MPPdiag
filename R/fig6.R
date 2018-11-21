# fig 6: proportion of apparent errors

library(broman)
library(qtl2)

svenson <- readRDS("../Data/svenson_v2.rds")
e <- readRDS("diag_cache/errorlod.rds")
e <- do.call("cbind", e)
errors_ind <- rowSums(e>2)/n_typed(svenson)*100


pdf("../Figs/fig6.pdf", width=6.5, height=3, pointsize=12)
par(mar=c(2.6, 3.3, 0.6, 0.6))
grayplot(errors_ind,
         xlab="Mouse", ylab="Percent genotyping errors",
         mgp.x=c(1.5,0.3,0), mgp.y=c(2.3,0.3,0),
         ylim=c(0, max(errors_ind)*1.05), yaxs="i")
wh <- which(errors_ind > 0.3)
adj <- setNames(rep(0, length(wh)), names(wh))
xadj <- setNames(rep(3, length(wh)), names(wh))
yadj <- setNames(rep(0, length(wh)), names(wh))
for(ind in c("M387", "M393", "M398", "M392", "M394")) { # label to left
    adj[ind] <- 1
    xadj[ind] <- -1 * xadj[ind]
}
yadj["M405"] <- -0.03
yadj["M411"] <- -0.13
xadj["M411"] <- 2
yadj["M413"] <- -0.10
yadj["M408"] <- +0.13
xadj["M408"] <- 2
yadj["M412"] <- +0.10

for(i in seq_along(wh)) {
    w <- wh[i]
    text(w + xadj[i],
         errors_ind[w] + yadj[i],
         names(errors_ind)[w],
         adj=adj[i], cex=0.7)
}
dev.off()
