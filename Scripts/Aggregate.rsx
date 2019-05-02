##Data Manipulation = group
##Layer=vector
##Field=Field Layer
##Aggregate_Output= output vector
library(raster)
Aggregate_Output <- raster::aggregate(Layer, Field)