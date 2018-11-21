# figure 1: proportion of missing genotypes by mouse

library(broman)
library(qtl2)

# original data file (291 individuals)
svenson <- readRDS("../Data/svenson_v0.rds")

# percent missing data by individual
pmis <- n_missing(svenson, "ind", "prop")*100

# ordered by ID and/or sex and/or generation?
#ngen <- svenson$covar$ngen
#ids <- names(pmis)
#sex_numer <- 1*(substr(ids, 1, 1)=="M")
#id_numer <- as.numeric(substr(ids, 2, nchar(ids)))
#pmis <- pmis[order(ngen, id_numer, sex_numer)]


pdf("../Figs/fig1.pdf", width=6.5, height=3, pointsize=10)
par(mar=c(3.1,3.1,1.1,1.1))

grayplot(pmis, xlab="Mouse", ylab="Percent missing genotypes",
         mgp.x=c(1.8,0.3,0), mgp.y=c(1.8,0.3,0),
         xaxs="i", yaxs="i", xlim=c(-1, n_ind(svenson)+2),
         yat=seq(0, 60, by=20),
         ylim=c(0, max(pmis)*1.05))

xd <- 3

# add labels
ids <- names(pmis)
big <- ids[pmis >= 19.97]
xadj <- setNames(rep(0, length(big)), big)
xadj["M388"] <- xadj["M387"] <- 1
for(mouse in big) {
    text(which(ids==mouse)+xd*ifelse(xadj[mouse]==0,1,-1), pmis[mouse], mouse, adj=c(xadj[mouse], 0.5), cex=0.7)
}

dev.off()
