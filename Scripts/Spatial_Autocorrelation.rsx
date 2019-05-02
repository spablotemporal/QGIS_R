####Spatial Statistics Tools = group
##Layer=vector
##Field=Field Layer
##Morans_I_DF = Output Table
##MinDistance = number
require(sp)
library(spdep)

wd <- dnearneigh(coordinates(Layer), 0, MinDistance)
ww <- nb2listw(wd, style = "B")
MI <- moran.test(Layer[[Field]], ww, randomisation = F)
Morans_I_DF <- round(data.frame(MI_Statistic = MI$estimate[1], Z_value = MI$statistic, pval = MI$p.value, row.names = ""), 4)