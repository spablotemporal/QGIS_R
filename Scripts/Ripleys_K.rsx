####Spatial Statistics Tools = group
##Layer = vector
##Area = vector
##DataFrame = Output Table
##showplots

library(spatstat)
Crds <- unique(coordinates(Layer))
Ext <- Area@bbox
xy <- ppp(x = Crds[,1], y = Crds[,2], Ext[1,], Ext[2,] )
plot(Kest(xy))