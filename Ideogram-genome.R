#colour regions of interest by density across the chromsomes
# code written by Matthew Flickinger

require(lattice)
require(grid)

read.cytobands <- function(filename) {
	dd <- read.table(filename, col.names=c("chr","start","stop","band","stain"))
	dd$chr <- factor(as.character(dd$chr), levels=paste("chr",c(1:22,"X","Y"), sep=""), ordered=T)
	return(dd)
}

panel.idioheatmap <- function(x,y, cytobands, gg, chr.width=.2, cent.width=.12, ...) {
	band.colors<-c(gneg="#FFFFFF", gpos25="#F4F4F4", 
		gpos50="#DEDEDE", gpos75="#C3C3C3", acen="#DEDEDE", 
		gvar="#C3C3C3", stalk="#C3C3C3")
	
	bin.size <- 5e6
	chrlen <- tapply(cytobands$stop, cytobands$chr, max)
	chrmaxlen <- max(chrlen)
	chrcounts <- table(x, cut(y, seq(0,chrmaxlen, by=bin.size)))
	maxchrcount <- max(chrcounts)
	print(maxchrcount)
	
	heatcolors <- rgb(1,seq(1,0,length.out=6),seq(1,0,length.out=6))
	heatbreaks <-  seq(0, maxchrcount, length.out=6)
	print(heatbreaks)
	
	for(i in 1:nrow(chrcounts)) {
		crow<-chrcounts[i,]
		for(j in 1:length(crow)) {
			grid.polygon(
				x=c(i-chr.width, 
					i+chr.width, 
					i+chr.width, 
					i-chr.width
				),
				y=c(bin.size*(j-1), bin.size*(j-1), bin.size*(j), bin.size*(j)),
				gp=gpar(fill=heatcolors[cut(crow[j], heatbreaks, include.lowest=T)],col=F),
				default.unit="native"
			)	
		}
	}
	
	centromere <- by(cytobands, cytobands$chr, function(x){
		sort(unique(unlist(x[x$stain=="acen",c("start","stop")])))
	})

	for (i in seq_along(chrlen)) {
		grid.polygon(
			x=c(i-chr.width, i-chr.width, i-cent.width, i-chr.width, i-chr.width, i+chr.width, i+chr.width, i+cent.width, i+chr.width,i+chr.width),
			y=c(0, centromere[[i]][1],centromere[[i]][2], centromere[[i]][3], chrlen[i],
				chrlen[i], centromere[[i]][3], centromere[[i]][2], centromere[[i]][1], 0),
			default.unit="native",
			gp=gpar(fill=F)
		)
	}
    #the following 3 lines were hashed out by Matthew Flickenger
    #with(subset(gg, PC==1), panel.points(CHR-chr.width, POS, col="blue", pch=19))
    #with(subset(gg, PC==2), panel.points(CHR, POS, col="green", pch=19))
    #with(subset(gg, PC==3), panel.points(CHR+chr.width, POS, col="purple", pch=19))
}

idiogram <- function(chr, pos, idiodata, gg) {
	xyplot(pos~chr, idiogram=idiodata, panel=function(x,y,idiogram,...) {
        panel.idioheatmap(x,y,idiogram, gg=gg, ...) }, 
		xlim=c(0,23), 
		ylim=c(-5e6,max(idiodata$stop)*1.1),
		#key=list(text=list(lab=c("PC1","PC2","PC3")), col=c("blue","green","purple"), points=list(pch=19)),
		scales=list(y=list(at=NULL), x=list(at=1:22)))
}

#cyto_path <- "/net/snowwhite/home/mflick/bridges/pca/gsk-minn-step-prech-vcu/cytoBandIdeo.txt" 
cyto_path <- "cytoBandIdeo.txt" #specify path to band locations from ucsc, see instructions and example at end
cyto <- read.cytobands(cyto_path)
cyto <- subset(cyto, chr<"chrX")
cyto$chr <- cyto$chr[,drop=T]

#cnv_path <- "/net/wonderland/home/mattz/BRIDGES/SVsummary/Overlaps/CNV_summary_Rtable.txt"
cnv_path <- "indel-forideogram" #specify your file of chromosome positions, see example at end
#cnv <- read.table(cnv_path, header=T, as.is=T)
cnv <- read.table(cnv_path, header=T, as.is=T, sep=":")
#cnv <- cbind(cnv, setNames(do.call("rbind.data.frame", strsplit(cnv$CNV, ":")), c("chr","pos")))

cnv$chr <-as.numeric(as.character(cnv$chr))
cnv$pos <-as.numeric(as.character(cnv$pos))
png("chrheatmap-allIndels.png",700,400)
print(with(cnv, 
	idiogram(factor(chr), pos, cyto)
))
dev.off()

##Colour codes:
# 0.0  - 23.8 --> 0 to 854.2 indels
# 23.8  47.6 --> 854.2 to 1708.4 indels
# 47.6 - 71.4 --> 1708.4 to 2562.6 indels
# 71.4  - 95.2 --> 2562.6 to 3416.8 indels
# 95.2 - 119.0 --> 3416.8 to 4271 indels

##Head of indel-forideogram
# chr:pos
# 1:100613480
# 1:100613488
# 1:10510170
# 1:109394468
# 1:109737182

##Head of cytoBandIdeo.txt (b37 version, can also get b38 version)

##file from from http://genome.ucsc.edu/cgi-bin/hgTables under group "Mapping and Sequencing" and track "Chromosome Banding (ideogram)"
##grep out chrM entries and all the random chromosomal reads 

##chrom	chromStart	chromEnd	name	gieStain
# chr1	0	2300000	p36.33	gneg
# chr1	2300000	5400000	p36.32	gpos25
# chr1	5400000	7200000	p36.31	gneg
# chr1	7200000	9200000	p36.23	gpos25
# chr1	9200000	12700000	p36.22	gneg

