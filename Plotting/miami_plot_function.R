# install.packages("readr")
# install.packages("ggrepel")
# install.packages("RColorBrewer")

library(readr)
library(ggrepel)
library(ggplot2)
library(dplyr)
library(RColorBrewer)

gg.miami <- function(path, df, hlight = NA, colours = c("#000000", "#999999"), ylims = c(-20,20), title = ""){
  # read and format df
  setwd(path)
  df <- read.delim(file = df, header = TRUE, sep = " ", colClasses = c("character","integer", "numeric", "numeric"))
  colnames(df) <- c("SNP","CHR","BP","Z")
  df.tmp <- df %>% 
    
    # Compute chromosome size
    group_by(CHR) %>% 
    summarise(chr_len=max(BP)) %>% 
    
    # Calculate cumulative position of each chromosome
    mutate(tot=cumsum(chr_len)-chr_len) %>%
    select(-chr_len) %>%
    
    # Add this info to the initial dataset
    left_join(df, ., by=c("CHR"="CHR")) %>%
    
    # Add a cumulative position of each SNP
    arrange(CHR, BP) %>%
    mutate( BPcum=BP+tot) %>%
    
    # Add highlight and annotation information
    mutate( is_highlight=ifelse(SNP %in% hlight, "yes", "no")) %>%
    mutate( is_annotate=ifelse(SNP %in% hlight, "yes", "no"))
  
  # get chromosome center positions for x-axis
  axisdf <- df.tmp %>% group_by(CHR) %>% summarize(center=( max(BPcum) + min(BPcum) ) / 2 )
  
    ggplot(df.tmp, aes(x=BPcum, y=P)) +
    # Show all points
    geom_point(aes(color=as.factor(CHR)), alpha=1, size=2) +
    scale_color_manual(values = rep(colours, 22 )) +
    
    # custom X axis:
    scale_x_continuous( label = axisdf$CHR, breaks= axisdf$center ) +
    scale_y_continuous(expand = c(0, 0), limits = ylims) + # expand=c(0,0)removes space between plot area and x axis 
    
    # add plot and axis titles
    ggtitle(paste0(title)) +
    labs(x = "Chromosome", y = "Z-score") +
    
    # add genome-wide sig lines
    #geom_hline(yintercept = zsig) +
    #geom_hline(yintercept = -1*zsig) +
    
    # Add highlighted points
    geom_point(data=subset(df.tmp, is_highlight=="yes"), color="red", size=3) +
    
    # Add label using ggrepel to avoid overlapping
    geom_label_repel(data=df.tmp[df.tmp$is_annotate=="yes",], aes(label=as.factor(SNP), alpha=1), size=8, force=1.3) +
    
    # Custom the theme:
    theme_bw(base_size = 22) +
    theme( 
      plot.title = element_text(hjust = 0.5),
      legend.position="none",
      panel.border = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank(),
      axis.text.x = element_text(size=16)
    )
}
