#DESCRIPTION
#Plot IBS0 vs. Kinshpi coef coloured by pairise relationship
#takes KING output as input, here called king.kin

library(ggplot2)

relp<-read.table("king.kin", h=T, as.is=T)

relp$relationship <- ifelse(relp$Kinship > 0.354,"MZ/Duplicates",ifelse(relp$Kinship > 0.177,"1st degree",ifelse(relp$Kinship > 0.0884,"2nd degree",ifelse(relp$Kinship>0.0442,"3rd degree","Unrelated (downsampled)"))))

png("kinship.png", width=600)
#If using a .ibs file in beginning (i.e. from flags --kinship --related --ibs given to King), calculate IBS0 via: 
#relp$IBS0 <- relp$N_IBS0/(relp$N_IBS0+relp$N_IBS1+relp$N_IBS2)
ggplot(aes(y=Kinship,x=IBS0), data=relp) + geom_point(aes(col=relationship)) + xlab("IBS0") + ylab("Kinship coef") 
dev.off()
