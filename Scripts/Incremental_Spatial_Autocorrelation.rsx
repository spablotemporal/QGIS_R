##Spatial Statistics Tools = group
##Layer=vector
##Field=Field Layer
##Begining_Distance = number
##Steps = number
##Distance_Increment = number
##showplots
##Incremental_Morans_I = Output Table
require(sp)
library(spdep)

  NDB <- c(Begining_Distance, Begining_Distance + Distance_Increment*1:Steps)
  DF <- data.frame(Distance = 0, I = 0, z = 0, p = 0)
  for (i in NDB) {
  wd <- dnearneigh(coordinates(Layer), 0, i)
  ww <- nb2listw(wd, style = "B")
  MI <- moran.test(Layer[[Field]], ww, randomisation = F)
  DFi <- cbind(Distance = i, I = MI$estimate[1], z = MI$statistic, p = MI$p.value)
  DF <- rbind(DF, DFi)
  }
DF <- DF[-1,]
  Incremental_Morans_I <- data.frame(round(DF,4), row.names = 0:Steps)
plot(z~Distance, data = DF, type = "l", ylab = "Z Score", main = "Spatial Autocorrelation by Distance")
grid(NA, 5, lwd = 2)
points(z~Distance, data = DF[DF$z == max(DF$z),], col = "cadetblue4", cex = 2.3, lwd = 3)
points(z~Distance, data = DF, col = heat.colors(length(NDB)), pch = 16, cex = 1.5)