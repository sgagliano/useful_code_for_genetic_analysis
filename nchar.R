#DESCRIPTION
#number of characters in one column minus the number of characters in another column within an R dataframe

#For example, x is data frame where V1 contains allele1 and V2 contains allele2
x$diff<-nchar(x$V2)-nchar(x$V1) #positive is insertion, negative is deletion; 0=SNP
