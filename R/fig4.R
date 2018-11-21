# genotype frequencies in individuals (with markers split by MAF)

library(broman)
library(qtl2)

gf_ind <- readRDS("diag_cache/snp_freq_ind.rds")

pdf("../Figs/fig4.pdf", width=6.5, height=5.5, pointsize=12)
par(mfrow=c(2,2), mar=c(0.6, 0.6, 2.1, 0.6))
for(i in 1:4) {
    triplot(c("AA", "AB", "BB"))
    title(main=paste0("MAF = ", i, "/8"), line=0.2)
    mtext(side=3, adj=0, font=2, LETTERS[i], line=0.2)
    tripoints(gf_ind[[i]], pch=21, bg="lightblue", cex=0.6)
    tripoints(c((1-i/8)^2, 2*i/8*(1-i/8), (i/8)^2), pch=21, bg="violetred", cex=0.7)


    if(i>=3) { # label mouse with lowest het
        wh <- which(gf_ind[[i]][,2] == min(gf_ind[[i]][,2]))

        trilines(rbind(gf_ind[[i]][wh,,drop=FALSE],
                       gf_ind[[i]][wh,,drop=FALSE] + c(0.09, -0.06, -0.030)))

        tripoints(gf_ind[[i]][wh,,drop=FALSE], pch=21, bg="lightblue", cex=0.6)

        tritext(gf_ind[[i]][wh,,drop=FALSE] + c(0.095, -0.065, -0.030),
                names(wh), adj=c(0, 1), cex=0.7)
    }

    # label other mice
    if(i==1) {
        lab <- rownames(gf_ind[[i]])[gf_ind[[i]][,2]>0.3]
    }
    else if(i==2) {
        lab <- rownames(gf_ind[[i]])[gf_ind[[i]][,2]>0.48]
    }
    else if(i==3) {
        lab <- rownames(gf_ind[[i]])[gf_ind[[i]][,2]>0.51]
    }
    else if(i==4) {
        lab <- rownames(gf_ind[[i]])[gf_ind[[i]][,2]>0.6]
    }

    for(ind in lab) {
        if((i==1 && ind %in% c("F326","M392")) ||
           (i==2 && ind %in% c("F326","M392","M388")) ||
           (i==3 && ind == "M388") ||
           (i==4 && ind == "F326")) {
            tritext(gf_ind[[i]][ind,,drop=FALSE] + c(-0.015, 0, +0.015), ind, adj=c(1,0.5), cex=0.7)
        } else if(i==3 && ind=="M392") {
            tritext(gf_ind[[i]][ind,,drop=FALSE] + c(-0.025, 0.02, +0.005), ind, adj=c(1,0.5), cex=0.7)
        } else if(i==3 && ind=="F326") {
            tritext(gf_ind[[i]][ind,,drop=FALSE] + c(-0.01, -0.01, +0.02), ind, adj=c(1,0.5), cex=0.7)
        } else if(i>1 && ind == "M405") {
            tritext(gf_ind[[i]][ind,,drop=FALSE] + c(-0.008, 0.016, -0.008), ind, adj=c(0.5,0), cex=0.7)
        } else {
            tritext(gf_ind[[i]][ind,,drop=FALSE] + c(0.015, 0, -0.015), ind, adj=c(0,0.5), cex=0.7)
        }
    }

}
dev.off()
