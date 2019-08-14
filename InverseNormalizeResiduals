##SET_UP
invnt = function(x) qnorm((rank(x,na.last="keep")-0.5)/sum(!is.na(x)))
resid_invnt = function(x,fmodel) invnt(resid(lm(as.formula(fmodel),data=x)))
resid2 = function(x,fmodel) resid(lm(as.formula(fmodel),data=x))

rawphenos = read.table("MyPhenosAndCovariates.txt", h=T, as.is=T)

##NUMBER OF DRINKS PER WEEK
# create the residuals for trait
rawphenos$trait_resid = resid(lm(trait~age+age2+AffySex+PC1+PC2+PC3+PC4+PC5+PC6+PC7+PC8+PC9+PC10+PC11+PC12+PC13+PC14+PC15+PC16+PC17+PC18+PC19+PC20,data=rawphenos,na.action=na.exclude))
#insert own covariates here

# perform the inverse-normal transform
rawphenos$trait_inv= invnt(rawphenos$trait_resid)

# rescale the transformed residuals to match the original trait distribution
rawphenos$trait_rintr= rawphenos$trait_inv * sqrt(var(rawphenos$trait_resid, na.rm = T))
