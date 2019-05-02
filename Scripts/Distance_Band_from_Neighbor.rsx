##Spatial Statistics Tools = group
##Layer = vector
##Distance_Band_DF = Output Table
require(sf)
Layer <- st_as_sf(Layer, quiet = T)
# First we Calculate the distance for all the neighbors
d <- sf::st_distance(Layer)
# Convert to a matrix:
dm <- as.matrix(d)
# Exclude the diagonal (Distance for each observation to itself will be 0)
diag(dm) <- NA
# Apply the min function to all the observations to obtain the min distance
dmin <- apply(dm, 1, min, na.rm = T)
# compute the max
Max <- max(dmin, na.rm = T)
Min <- min(dmin, na.rm = T)
Mean <- mean(dmin, na.rm = T)
Median <- median(dmin, na.rm = T)

Distance_Band_DF  <- round(data.frame(Max, Min, Mean, Median), 4)