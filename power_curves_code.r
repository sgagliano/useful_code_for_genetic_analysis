pdf('powercurve.pdf')

#based on https://www.mv.helsinki.fi/home/mjxpirin/GWAS_course/material/GWAS3.html
###OR=1.1, MAF=0.5
b = log(1.1) #b is log-odds, approximately GRR for a low prevalence disease
n = seq(1000, 100000, 1000) # candidate n
#n = 20000
f = 0.5
phi = 0.5
pwr = pchisq(qchisq(5e-8, df = 1, lower = F), df = 1, ncp = 2*f*(1-f)*n*phi*(1-phi)*b^2, lower = F)

or = exp(b)
or.round = signif(or, 2)

plot(n,pwr, col = "darkgreen", xlab = "n cases+controls (where proportion of cases is 0.5)", ylab = "power", ylim=c(0,1.0),
     main = paste0("OR=", or.round), t = "l", lwd = 1.5)
#main = paste0("MAF=",f,"; OR=",or.round), t = "l", lwd = 1.5)

par(new=T)

###OR=1.1, MAF= 0.1
b = log(1.1) #b is log-odds, approximately GRR for a low prevalence disease
n = seq(1000, 100000, 1000) # candidate n
#n = 20000
f = 0.1
phi = 0.5
pwr = pchisq(qchisq(5e-8, df = 1, lower = F), df = 1, ncp = 2*f*(1-f)*n*phi*(1-phi)*b^2, lower = F)

or = exp(b)
or.round = signif(or, 2)

plot(n,pwr, col = "blue", xlab = "n cases+controls (where proportion of cases is 0.5)", ylab = "power", ylim=c(0,1.0), t = "l", lwd = 1.5)

par(new=T)

###OR=1.1, MAF= 0.05
b = log(1.1) #b is log-odds, approximately GRR for a low prevalence disease
n = seq(1000, 100000, 1000) # candidate n
#n = 20000
f = 0.05 
phi = 0.5
pwr = pchisq(qchisq(5e-8, df = 1, lower = F), df = 1, ncp = 2*f*(1-f)*n*phi*(1-phi)*b^2, lower = F)

or = exp(b)
or.round = signif(or, 2)

plot(n,pwr, col = "orange", xlab = "n cases+controls (where proportion of cases is 0.5)", ylab = "power", ylim=c(0,1.0), t = "l", lwd = 1.5)

abline( h = 0.8, lty = 2 )

legend("right", title="MAF", c("0.5", "0.1", "0.05"), lty=c(1, 1, 1), col=c("darkgreen", "blue", "orange"))

dev.off()
