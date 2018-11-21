# grab intensities from GeneSeek FinalReport.txt files
# convert them to a single big data frame, and save for use with fst

library(fst)

# simple version of data.table::fread()
myfread <- function(filename) data.table::fread(filename, data.table=FALSE, skip=9)

ifiles <- paste0("RawData/",
                 c("Jackson_Lab_Mouse_30jan2013_FinalReport.txt",
                   "Jackson_Lab-Ciciotte_Mouse_05jun2013_FinalReport.txt"))

dat <- NULL
for(file in ifiles) {
    if(is.null(dat)) dat <- myfread(file)[,c("SNP Name", "Sample ID", "X", "Y")]
    else dat <- rbind(dat, myfread(file)[,c("SNP Name", "Sample ID", "X", "Y")])
}

# create matrices that are snps x samples
snps <- unique(dat[,1])
samples <- unique(dat[,2])
X <- Y <- matrix(ncol=length(samples), nrow=length(snps))
dimnames(X) <- dimnames(Y) <- list(snps, samples)
for(i in seq(along=samples)) {
    cat(i, "of", length(samples), "\n")
    tmp <- dat[dat[,2]==samples[i],]
    X[,samples[i]] <- tmp[,3]
    Y[,samples[i]] <- tmp[,4]
}

# bring together in one matrix
result <- cbind(snp=rep(snps, 2),
                channel=rep(c("X", "Y"), each=length(snps)),
                as.data.frame(rbind(X, Y)))
rownames(result) <- 1:nrow(result)

# bring SNP rows together
result <- result[as.numeric(t(cbind(seq_along(snps), seq_along(snps)+length(snps)))),]
rownames(result) <- 1:nrow(result)

# write to fst file
write.fst(result, "RawData/intensities.fst", compress=100)
