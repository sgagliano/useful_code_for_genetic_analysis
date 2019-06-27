#DESCRIPTION
#Get the genomic control lambda (and perform genomic control correction)
#Assumes input file is called MyFile.txt and PVALUE is the column name containing the association p-values in the file

data<-read.table("MyFile.txt", h=T, as.is=T)
p=data$PVALUE # p means p-value column name
Zsq=qchisq(1-p, 1)
#if output some Zsq as inf use the following:
#Zsq=qchisq(p, 1, lower.tail=F)
lambda=median(Zsq)/0.456
lambda #print out GC lambda
newZsq=Zsq/lambda #GC correct Zsq
Newp=1-pchisq(newZsq, 1) #GC correct PVALUE

#to get mean and median lambda; in terminal
#grep -v -w NA Pvals.txt | /usr/cluster/bin/hist --bin 0.05
