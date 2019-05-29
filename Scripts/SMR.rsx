##Epi Tools = group
##Layer=vector
## Observed = Field Layer
## Population = Field Layer
## SMR = output vector

O <- Layer[[Observed]]
P <- Layer[[Population]]

r <- sum(O) / sum(P)

E <- P * r
smr <- O / E

SPDF <- SpatialPolygons(Layer@polygons, pO = Layer@plotOrder, proj4string = Layer@proj4string)
DF <- data.frame(ID = names(SPDF), Population = P, Observed = O, Expected = E, SMR = smr)
SMR <- SpatialPolygonsDataFrame(SPDF, data = DF, match.ID = F)