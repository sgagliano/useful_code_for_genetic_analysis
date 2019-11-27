#DESCRIPTION
#Example of a for else loop in R to iterate over all lines in a dataframe called x

for (i in 1:nrow(x)) { 
if (x[i,2]<0) #if a column 2 entry is less than 0
x[i,5]<-x[i,4]*-1 #make the value of column 5 the value of column 4 times -1
else
x[i,5]<-x[i,4] #else make the value of column 5 the value of column 4
}

#another example with 2 loops and incrementing the index
x<-read.table("batch.txt", as.is=T, h=T)
index=1
for (j in seq(from=11,to=91,by=1)){
	index=index+1	
	for (i in 1:nrow(x)) { 
		if (x[i,1]==j) 
		x[i,index]<-1 
		else
		x[i,index]<-0	
		}
}
