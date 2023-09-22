#if(!require(devtools)) install.packages("devtools")
#devtools::install_github("kassambara/ggpubr")
library(ggpubr)
library("ggplot2")

#see readme-cds.txt

x<-read.table("table-jointplot.txt", as.is=T, h=T, sep=" ")
chrX<-subset(x, x$chr=="X")
chrY<-subset(x, x$chr=="Y")
prep<-subset(x, x$chr!="X")
autosomes<-subset(prep, prep$chr!="Y")

#pdf("gwascat-cds.pdf")
bxp <- ggplot(x, aes(x=length_bp_Genome_Reference_Consortium_b38 , y=N_variants, group=Group, color=Group)) +
  geom_point(aes(shape=Group)) +
  scale_color_brewer(palette="Dark2") +
  theme(legend.position="none", legend.title = element_blank()) +
  xlab("Base pair length") +
  ylab("N variants in GWAS Catalog") +
  geom_text(aes(label = chr), hjust = 0.5,  vjust = -1, size=4) +
  ylim(0, 21000) +
 geom_smooth(method = "lm",  n=22)
 #dev.off()

#pdf("gwascat-cds.pdf")
dp <- ggplot(x, aes(x=cds_gencode.v44.primaryassembly.Ensemblcanonical.proteincoding.cds, y=N_variants, group=Group, color=Group)) +
  geom_point(aes(shape=Group)) +
  scale_color_brewer(palette="Dark2") +
  theme(legend.position="none", legend.title = element_blank()) +
  xlab("Coding sequence length of canonical transcripts of protein coding genes") +
  ylab("N variants in GWAS Catalog") +
  geom_text(aes(label = chr), hjust = 0.5,  vjust = -1, size=4) +
  ylim(0, 21000) +
 geom_smooth(method = "lm",  n=22)
 #dev.off()

myplot<-ggarrange(bxp, dp, labels = c("a", "b"), ncol = 2, nrow = 1)
          
ggsave("Fig3-ggplot-gwascatfig-ab.pdf", plot= myplot, scale=1, width=13.5, height=6.5, units="in", dpi=300, limitsize=TRUE)
