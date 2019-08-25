#DESCRIPTION
#Example code plotting overlapping histograms for subsets of data (waves0-6), with corner text and a legend added

#create multiple overlapping histograms colour-coded by "wave"
x<-read.table("<my_data_file>", as.is=T)
pdf("<my_pdf_predix>.pdf")
summary <- summary(x$V23) #replace V23 with the column ID of the column on which you want to perform the summary function
        Corner_text <- function(text, location="topright"){
            legend(location,legend=text, bty ="n", pch=NA)
        }

waves<-read.table("<my_wave_file", as.is=T)
data<-merge(x, waves, by.x="V1", by.y="V1") #replace V1 with the appropriate column IDs on which to match
wave0<-subset(data, data$V2.y=="wave0")
wave1<-subset(data, data$V2.y=="wave1")
wave2<-subset(data, data$V2.y=="wave2")
wave3<-subset(data, data$V2.y=="wave3")
wave4<-subset(data, data$V2.y=="wave4")
wave5<-subset(data, data$V2.y=="wave5")
wave6<-subset(data, data$V2.y=="wave6")

#means
total <-round(mean(x$V23), digits=2)
zero <- round(mean(wave0$V23), digits=2)
one <- round(mean(wave1$V23), digits=2)
two <- round(mean(wave2$V23), digits=2)
three <- round(mean(wave3$V23), digits=2)
four <- round(mean(wave4$V23), digits=2)
five <- round(mean(wave5$V23), digits=2)
six <- round(mean(wave6$V23), digits=2)

hist(wave0$V23, main="", xlab="", ylab="", col=rgb(0,0,1,1/4), breaks=20, xlim=c(10,65), ylim=c(0,505))
par(new=T)
hist(wave1$V23, main="", xlab="", ylab="", col=rgb(1,0,0,1/4), breaks=20, xlim=c(10,65), ylim=c(0,505))
par(new=T)
hist(wave2$V23, main="", xlab="", ylab="", col=rgb(0,1,0,1/4), breaks=20, xlim=c(10,65), ylim=c(0,505))
par(new=T)
hist(wave3$V23, main="", xlab="", ylab="", col=rgb(1,1,0,1/4), breaks=20, xlim=c(10,65), ylim=c(0,505))
par(new=T)
hist(wave4$V23, main="", xlab="", ylab="", col=rgb(0,1,1,1/4), breaks=20, xlim=c(10,65), ylim=c(0,505))
par(new=T)
hist(wave5$V23, main="", xlab="", ylab="", col=rgb(1,0,1,1/4), breaks=20, xlim=c(10,65), ylim=c(0,505))
par(new=T)
hist(wave6$V23, main="<My title>", xlab="<X Label>", ylab="Count", col=rgb(1,0,1,1/2), breaks=20, xlim=c(10,65), ylim=c(0,505))
#Corner_text(text=paste(" min ",summary[1],"\n mean ", summary[4],"\n median ",summary[3],"\n max ",summary[6],sep=""))
Corner_text(text=paste(" all_mean ",total,"\n 0 ", zero,"\n 1 ",one,"\n 2 ",two,"\n 3 ",three,"\n 4 ",four,"\n 5 ",five,"\n 6 ",six,sep=""))

legend("topleft", title="Wave", c("0", "1", "2", "3", "4", "5", "6"), pch=c(15, 15, 15, 15, 15, 15, 15), col=c(rgb(0,0,1,1/4), rgb(1,0,0,1/4), rgb(0,1,0,1/4), rgb(1,1,0,1/4),rgb(0,1,1,1/4),rgb(1,0,1,1/4), rgb(1,0,1,1/2)))

dev.off()
