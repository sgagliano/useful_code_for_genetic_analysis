#DESCRIPTION
#Example of a for else loop in R to iterate over all lines in a dataframe called x

for (i in 1:nrow(x)) { 
if (x[i,2]<0) #if a column 2 entry is less than 0
x[i,5]<-x[i,4]*-1 #make the value of column 5 the value of column 4 times -1
else
x[i,5]<-x[i,4] #else make the value of column 5 the value of column 4
}
