##WRITTEN BY LARS FRITSCHE
options(stringsAsFactors=F)
library("plotrix")
library("data.table")
library("RColorBrewer")
library("optparse")

option_list <- list(
  make_option("--input", type="character", default="",
    help="Input file, tab delimited"),   
  make_option("--prefix", type="character", default="",
    help="Prefix of output files"),   
  make_option("--top.size", type="numeric", default=0.125,
    help="top size = proportion of total length y axis [default=0.125]"),
  make_option("--break.top", type="numeric", default=15,
    help="set axis break at -log10(P) [default=15]"),
  make_option("--width", type="numeric", default=11,
    help="Width Manhattan plot in inch [default=11]"),
  make_option("--height", type="numeric", default=8.5,
    help="Height Manhattan plot in inch [default=8.5]"),
  make_option("--pointsize", type="numeric", default=10,
    help="Point size of plots [default=10]"),
  make_option("--hitgenes", type="character", default="",
    help="File with candidate genes, CHROM;START;COL;GENE [default='']"),
  make_option("--chr", type="character", default="CHR",
    help="name of column with chromosome [default='CHR']"),
  make_option("--pos", type="character", default="POS",
    help="name of column with position [default='POS']"),
  make_option("--pvalue", type="character", default="PVALUE",
    help="name of column with p.value [default='PVALUE']"),
  make_option("--log10p", type="logical", default=F,
    help="Input p.value column with -log10(p.value) [default=F]"),    
  make_option("--gene", type="character", default="GENE",
    help="name of column with gene name [default='GENE']"),
  make_option("--ntests", type="integer", default=20000,
    help="Number of tests"),    	  	
  make_option("--maintitle", type="character", default="",
    help="Plot title")  
)

parser <- OptionParser(usage="%prog [options]", option_list=option_list)

args <- parse_args(parser, positional_arguments = 0)
opt <- args$options

chrcol <- opt$chr
poscol <- opt$pos
genecol <- opt$gene

# horizontal lines and corresponding colors
yLine <- c(-log10(0.05/opt$ntests))
colLine <- c("red")

gwas <- fread(opt$input)

if(!opt$log10p) {
	gwas$log10P <- -log10(gwas[[opt$pvalue]])
	ycol <- "log10P"
} else {
	ycol <- opt$pvalue
}

gwas <- na.omit(data.frame(gwas[,c(chrcol,poscol,ycol,genecol),with=F]))
gwas <- gwas[order(as.numeric(gsub("chr","",gwas[[chrcol]])),as.numeric(gwas[[poscol]])),]

hits <- which(gwas$log10P >= yLine)

if (opt$hitgenes != ""){
	candidateGenes <- read.table(opt$hitgenes,sep="\t",header=T,check.names=F,comment.char="")
} else if (opt$hitgenes == "" & length(hits)>0) {
	candidateGenes <- data.frame(
		'CHROM'=gwas[[chrcol]][hits],
		'START'=gwas[[poscol]][hits],
		'COL'="blue",
		'GENE'=gwas[[genecol]][hits]
		)
} else {
	candidateGenes <- data.frame(
		'CHROM'=character(0),
		'START'=numeric(0),
		'COL'=character(0),
		'GENE'=character(0)
		)
}

# Prepare plot data / two-colored chromosomes / with fixed gap
CHR <- gwas[[chrcol]]
POS <- gwas[[poscol]]
log10P <- gwas[[ycol]]
chrs <- c(1:22,"X",23,"Y",24,"XY",25,"MT",26)
chrs <- c(chrs,paste0("chr",chrs))
chrs <- chrs[which(chrs %in% CHR)]
chrNr <- as.numeric(gsub("chr","",as.character(factor(CHR,levels=chrs,labels=1:length(chrs)))))
chrColors <- c("grey40","grey60")[(1:length(chrs)%%2)+1]
names(chrColors) <- chrs
plotdata <- data.frame(
    CHR,
    POS,
    log10P,
    'plotPos'=NA,
    'chrNr'= chrNr,
    'pch'=20,
    'highlightColor'=NA,
    'pcol'=chrColors[CHR],
    check.names=F)
endPos <- 0
plotPos <- numeric(0)
chrLab <- numeric(0)
chrGAP <- 1E7
for(chr in chrs){
    chrTemp <- which(CHR == chr)
    chrPOS <- POS[chrTemp]-min(POS[chrTemp],na.rm=T)+endPos+1
    chrLab <- c(chrLab,mean(chrPOS,na.rm=T))
    endPos <- max(chrPOS,na.rm=T)+chrGAP
    plotPos <- c(plotPos,chrPOS)
}
plotdata$plotPos <- plotPos
chrs <- gsub("chr","",chrs)

# update numeric non-autosomal chromosome names
fixChr <- c(1:22,"X","Y","XY","MT","X","Y","XY","MT")
names(fixChr) <- c(1:26,"X","Y","XY","MT")
chrs <- fixChr[chrs]

# Highlight candidate regions
if(dim(candidateGenes)[1]>0){
	a <- 0
	while(a < dim(candidateGenes)[1]){
		a <- a + 1 
		overlap <- which(plotdata$CHR == candidateGenes$CHROM[a] &
					 plotdata$POS == candidateGenes$START[a] &
					 is.na(plotdata$highlightColor)
				)
		if(length(overlap)==0) next
		plotdata$highlightColor[overlap] <- candidateGenes$COL[a]
		plotdata$pcol[overlap] <- NA
	}
}

# Manhattan plot
pdf(file = paste0(opt$prefix,"_Manhattan.pdf"), width = opt$width, height = opt$height, pointsize = opt$pointsize)
    par(mar=c(5.1,5.1,4.1,1.1),las=1)
    x = plotdata$plotPos
    y = plotdata$log10P
    maxY <- max(y,na.rm=T)

	# Version with two y axes
    if(maxY > opt$break.top/(1 - opt$top.size)){
        # Manhattan plot with two different y axis scales

        # set axis labels of both scales
        lab1 <- pretty(c(0,opt$break.top),n=ceiling(12 * (1-opt$top.size)))
        lab1 <- c(lab1[lab1 < opt$break.top],opt$break.top)
        lab2 <- pretty(c(opt$break.top,maxY),n=max(3,floor(12 * opt$top.size)))
        lab2 <- lab2[lab2 > max(lab1)]

        # resulting range of top scale in bottom scale units
        top.range = opt$break.top/(1 - opt$top.size) - opt$break.top
        top.data = max(lab2)-opt$break.top
        # function to rescale the top part
        rescale = function(y) {opt$break.top+(y-opt$break.top)/(top.data/top.range)}

        # plot bottom part / rescaled
        plot(x[y<opt$break.top],y[y<opt$break.top],ylim=c(0,opt$break.top+top.range),axes=FALSE,
            pch=plotdata$pch[y<opt$break.top], cex=0.9,cex.lab=1.5,cex.axis=1.5, xaxt="n",
            col=plotdata$pcol[y<opt$break.top], ylab=expression(-log[10]*italic(P)), xlab="",bty="n",
            main=gsub("_"," ",paste0(opt$maintitle,"\n",format(opt$ntests,big.mark=",",scientific=F),
            " Tested Genes")))
        # plot top part
        points(x[y>opt$break.top],rescale(y[y>opt$break.top]),pch=plotdata$pch[y>opt$break.top],
            col=plotdata$pcol[y>opt$break.top],cex=0.9)

        # plot highlighted regions
        for(a in 1:nrow(candidateGenes)){
			b <- which(plotdata$CHR == candidateGenes$CHROM[a] &
						 plotdata$POS == candidateGenes$START[a])
			if(length(b)==0) next
			genedata <- plotdata[b,]
            if(genedata$log10P > opt$break.top) {
                points(genedata$plotPos,rescale(genedata$log10P),pch=20,col=candidateGenes$COL[a], cex=0.9)
                text(genedata$plotPos,rescale(genedata$log10P),candidateGenes$GENE[a],pos=2,font=4)
            } else {
                points(genedata$plotPos,genedata$log10P,pch=20,col=candidateGenes$COL[a], cex=0.9)
                text(genedata$plotPos,genedata$log10P,candidateGenes$GENE[a],pos=2,font=4)
            }
        }

        # add axes and axis labels
        axis(1,at=chrLab[seq(1,length(chrLab),by=2)],
            labels=chrs[1:length(chrLab)][seq(1,length(chrLab),by=2)],
            las=1,tick=F,cex.axis=1.5,cex.lab=1.5,line=2)
        axis(1,at=chrLab[seq(2,length(chrLab),by=2)],
            labels=chrs[1:length(chrLab)][seq(2,length(chrLab),by=2)],
            las=1,tick=F,cex.axis=1.5,cex.lab=1.5,line=0)
        axis(side=2,at=lab1,cex.axis=1.5,cex.lab=1.5)
        axis(side=2,at=rescale(lab2),labels=lab2,cex.axis=1.5,cex.lab=1.5)

        # plot axis breaks and indicate line of axis break
        box()
        axis.break(axis=2,breakpos=opt$break.top,style="zigzag",brw=0.02)
        axis.break(axis=4,breakpos=opt$break.top,style="zigzag",brw=0.02)
        abline(h=opt$break.top,lwd=1.5,lty=2,col="grey")
        if(length(yLine)>0) {
            for(rl in 1:length(yLine)){
                if(yLine[rl] <= opt$break.top) {
                    abline(h=yLine[rl],lwd=1.5,col=colLine[rl],lty=2)
                } else {
                    abline(h=rescale(yLine[rl]),lwd=1.5,col=colLine[rl],lty=2)
                }
            }
        }
	# Version with one y axis / no break in axis
    } else {
        plot(x,y,xaxt="n",pch=plotdata$pch,cex=0.9,cex.lab=1.5,cex.axis=1.5,xaxt="n",
            col=plotdata$pcol,ylab=expression(-log[10]*italic(P)),xlab="",bty="o",
            main=gsub("_"," ",paste0(opt$maintitle,"\n",format(opt$ntests,big.mark=",",scientific=F),
            	" Tested Genes")),
            ylim=c(0,ceiling(max(maxY+1,yLine))))
        axis(1,at=chrLab[seq(1,length(chrLab),by=2)],
            labels=chrs[1:length(chrLab)][seq(1,length(chrLab),by=2)],
            las=1,tick=F,cex.axis=1.5,cex.lab=1.5,line=2)
        axis(1,at=chrLab[seq(2,length(chrLab),by=2)],
            labels=chrs[1:length(chrLab)][seq(2,length(chrLab),by=2)],
            las=1,tick=F,cex.axis=1.5,cex.lab=1.5,line=0)
        # plot highlighted regions on top
        for(a in 1:nrow(candidateGenes)){
			b <- which(plotdata$CHR == candidateGenes$CHROM[a] &
						 plotdata$POS == candidateGenes$START[a])
			if(length(b)==0) next
			genedata <- plotdata[b,]
			points(genedata$plotPos,genedata$log10P,pch=20,col=candidateGenes$COL[a], cex=0.9)
            text(genedata$plotPos,genedata$log10P,candidateGenes$GENE[a],pos=2,font=4)
        }
        # genome-wide significance linn
        if(length(yLine)>0) abline(h=yLine,lwd=1.5,col=colLine,lty=2)
    }
dev.off()
