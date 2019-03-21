# fig 7: missing data vs proportion errors by marker

library(qtl2)
library(broman)

svenson <- readRDS("../Data/svenson_v2.rds")

pmis_mar <- n_missing(svenson, "marker", "proportion")*100
e <- readRDS("diag_cache/errorlod.rds")
e <- do.call("cbind", e)

errors_mar <- colSums(e>2)/n_typed(svenson, "marker")*100

for(type in c("png", "jpg")) {
if(type=="png") png("../Figs/fig7.png", width=6.5, height=3, pointsize=12, units="in", res=300)
else jpeg("../Figs/fig7.jpg", width=6.5, height=3, pointsize=12, units="in", res=300)
par(mar=c(3.1,3.1,0.6,0.6))
grayplot(pmis_mar, errors_mar,
         xlab="Proportion missing", ylab="Proportion genotyping errors",
         mgp.x=c(1.5, 0.3, 0), mgp.y=c(1.9, 0.3, 0),
         yat=seq(0, 100, by=20), vlines=seq(0, 100, by=20),
         xlim=c(-0.3, max(pmis_mar)*1.05), ylim=c(-0.3, max(errors_mar)*1.05),
         xaxs="i", yaxs="i")

# Add labels
bad <- which(errors_mar > 50)
xd <- setNames(rep(0.7, length(bad)), names(bad))
yd <- setNames(rep(0, length(bad)), names(bad))
yd["UNC169874"] <- -1
yd["UNC20478577"] <- -1.5
yd["UNC26588771"] <- +1
yd["UNC15195666"] <- +0.5
yd["UNC070074203"] <- -0.5
adj <- setNames(rep(0, length(bad)), names(bad))
adj["UNC20278347"] <- 1
xd["UNC20278347"] <-  -0.7
yd["UNC20278347"] <-  +1
for(i in seq_along(bad)) {
    text(pmis_mar[bad[i]]+xd[names(bad)[i]],  errors_mar[bad[i]] + yd[names(bad)[i]],
         names(bad)[i], cex=0.7, adj=c(adj[names(bad)[i]], 0.5))
}

dev.off()
}
