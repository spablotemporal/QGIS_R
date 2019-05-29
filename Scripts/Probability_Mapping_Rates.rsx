##Epi Tools = group
##Layer=vector
## Observed = Field Layer
## Population = Field Layer
## ProbMap = output vector

O <- Layer[[Observed]]
P <- Layer[[Population]]

r <- sum(O) / sum(P)

E <- P * r



pmap <- spdep::probmap(O, P)
Pmap <- pmap$pmap
E_Counts <- pmap$expCount
RR <- pmap$relRisk

SPDF <- SpatialPolygons(Layer@polygons, pO = Layer@plotOrder, proj4string = Layer@proj4string)
DF <- data.frame(ID = names(SPDF), Population = P, Observed = O, Expected_Counts = E_Counts, Relative_Risk = RR, Pmap = Pmap)
ProbMap <- SpatialPolygonsDataFrame(SPDF, data = DF, match.ID = F)