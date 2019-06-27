#DESCRIPTION
#In this example:
#randomly sample 1566 lines 1000 times from the first column of my_file.txt (which is read as a dataframe x in R), and then write out these 1000 permutations into separate files.

#list of people- first column in :
x<-read.table("my_file.txt", as.is=T)

#sample 1566 lines
k=1566

#do 1000 permutations
N_perm=1000

#create epty matrix to store resuts from permutations
mat <- matrix("NA", nrow = k, ncol = N_perm)

for (i in 1:N_perm){
mat[,i]=sample(x[,1], k) #want to select the first column of dataframe x
}

#write out results
for (i in 1:N_perm){
write.table(mat[,c(i,i)], paste(i, ".permute.txt", sep=""), row.names=F, col.names=F, quote=F)
}
