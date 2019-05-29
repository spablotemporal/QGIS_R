##Epi Tools = group
##Layer=vector
## Observed = Field Layer
## Expected = Field Layer
## EBlocal = output vector

library(spdep)

O <- Layer[[Observed]]
E <- Layer[[Expected]]

nbqueen <- poly2nb(Layer, queen = T)
 
res <- EBlocal(O, E, nbqueen)



SPDF <- SpatialPolygons(Layer@polygons, pO = Layer@plotOrder, proj4string = Layer@proj4string)
EBlocal <- SpatialPolygonsDataFrame(SPDF, data = res, match.ID = F)