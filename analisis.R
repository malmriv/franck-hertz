#Libraries
library(pracma)
library(latex2exp)
library(errors)

#Read every file, import each magnitude into different data file
files = list.files(pattern="*.txt")
names = gsub(".txt","",files)
v = as.data.frame(matrix(nrow=2500,ncol=15,data=NA))
int = as.data.frame(matrix(nrow=2500,ncol=15,data=NA))

#This looks horrible but it works (just copying column-by-column does not
#work because each file has a different length)
for(i in 1:length(files)) {
  temp = read.table(files[i],skip=2,sep="\t",dec=",")
  for(j in 1:length(temp[,1])) {
    v[j,i] = temp$V1[j]
    int[j,i] = temp$V2[j]
  }
}

#Temperature and potential array (to show names on plots, not relevant)
temp = c("T = 120 °C","T = 150 °C", "T = 170 °C", "T = 190 °C", "T = 220 °C")
frenado = c("2.0 V","0.5 V", "1.0 V")
  
#Plot all graphs
par(mfrow=c(5,3))
for(i in 15:15) {
  plot(v[,i],int[,i],type="l",xlab="V (V)",ylab="I (mA)",col="navyblue",lwd=0.7,
       main=paste(temp[ceiling(i/3)],", V(frenado) = ",frenado[i%%3+1],sep=""))
}

#Find minima and maxima
  for(i in 15:15) {
    par(mfrow=c(1,3))
    
  #Smooth interpolation to avoid the effects of noise
  polinom = loess(int[,i]~v[,i],span=0.08)
  plot(v[,i],predict(polinom,v[,i]),type="l",lty=1,col="navyblue",
       main=paste(temp[ceiling(i/3)],", V(frenado) = ",frenado[i%%3+1],sep=""),
       xlab="V (V)",ylab="I (mA)")
  legend("topleft",c("Máximos","Mínimos"),pch=c(19,19),
         col=c("orange","red"))
  

  #Find positions of maxima and minina
  maxima = findpeaks(round(predict(polinom,v[,i]),5),nups=3,ndowns=3)
  minima = findpeaks(-round(predict(polinom,v[,i]),5),nups=3,ndowns=3)
  
  #Avoid spurious maxima due to smoothing
  #maxima = maxima[-(length(maxima[,1])),]


  #Show on graph (for verification purposes, not essential)
  lines(v[maxima[,2],i],int[maxima[,2],i],col="orange",type="p",pch=19)
  lines(v[minima[,2],i],int[minima[,2],i],col="red",type="p",pch=19)
  
  #Find difference in V between maxima and minima and plot
  dif_max = diff(v[maxima[,2],i])
  dif_min = diff(v[minima[,2],i])
  difs = sort(c(dif_min,dif_max))
  
  #Select outliers
  outliers_max = c(1,2)
  outliers_min = c(2)
  
  #Plot and make model
  plot(c(1:length(dif_min)),dif_min,main="Separación entre mínimos.",type="p",
       xlab="orden (adim.)", ylab=TeX("$\\Delta V$ (V)"),pch=19,col="navyblue")
  modelmin = lm(dif_min[-outliers_min]~c(1:length(dif_min))[-outliers_min])
  abline(modelmin,lty=2,lwd=1.5,col="navyblue")
  lines(c(1:length(dif_min))[outliers_min],dif_min[outliers_min],col="red",
        pch=19,type="p")
  legend("topright",c("Outliers","Puntos ajustados"),pch=c(19,19),col=c("red","navyblue"))
  
  #Compute lambda and Ea
  L = 7e-3
  errors(L) = 0.1e-3
  pend = summary(modelmin)$coefficients[2,1]
  errors(pend) = summary(modelmin)$coefficients[2,2]
  interc = summary(modelmin)$coefficients[1,1]
  errors(interc) = summary(modelmin)$coefficients[1,2]
  lambda = L*(pend/(2*interc+pend))
  Ea = interc + pend/2
  print("MINIMOS")
  print(format(lambda,notation="plus-minus"))
  print(format(Ea,notation="plus-minus"))

  
  #Plot and make model
  plot(c(1:length(dif_max)),dif_max,main="Separación entre máximos.",type="p",
       xlab="orden (adim.)", ylab=TeX("$\\Delta V$ (V)"),pch=19,col="navyblue")
  modelmax = lm(dif_max[-outliers_max]~c(1:length(dif_max))[-outliers_max])
  abline(modelmax,lty=2,lwd=1.5,col="navyblue")
  lines(c(1:length(dif_max))[outliers_max],dif_max[outliers_max],col="red",
        pch=19,type="p")
  legend("topright",c("Outliers","Puntos ajustados"),pch=c(19,19),col=c("red","navyblue"))
  
  #Compute lambda and Ea
  L = 7e-3
  errors(L) = 0.1e-3
  pend = summary(modelmax)$coefficients[2,1]
  errors(pend) = summary(modelmax)$coefficients[2,2]
  interc = summary(modelmax)$coefficients[1,1]
  errors(interc) = summary(modelmax)$coefficients[1,2]
  lambda = L*(pend/(2*interc+pend))
  Ea = interc + pend/2
  print("MAXIMO")
  print(format(lambda,notation="plus-minus"))
  print(format(Ea,notation="plus-minus"))
  
  }
