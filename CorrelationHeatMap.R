#DESCRRIPTION
#plot the correlatino

library(corrplot)

R<-read.table("DataMatrix-withRowandColNames", as.is=T, h=T, row.names=1)

R<-as.matrix(R)

#plot correlation using the square method
png("corr-square.png", width=1000, height=1000, res=110)
corrplot(R, method="square")
dev.off()

#plot correlations as numeric entires
png("corr-nums.png", width=1000, height=1000, res=110)
corrplot(R, method="number")
dev.off()
