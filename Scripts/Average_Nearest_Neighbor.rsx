####Spatial Statistics Tools = group
##Layer = vector
##Area = vector
##NN_Mean_Distance_DF = Output Table
require(sf)
Layer <- st_as_sf(Layer, quiet = T)
Area<- st_as_sf(Area, quiet = T)

#Calculate the area:
Area <- as.numeric(sf::st_area(Area))
# First we Calculate the distance for all the neighbors
d <- sf::st_distance(Layer)
# Convert to a matrix:
dm <- as.matrix(d)
# Exclude the diagonal (Distance for each observation to itself will be 0)
diag(dm) <- NA
# Apply the min function to all the observations to obtain the min distance
dmin <- apply(dm, 1, min, na.rm = T)
 # compute the mean
 Observed <- mean(dmin, na.rm = T)
  
n <- nrow(Layer)
# Compute the expected mean distance
Expected <- 0.5/sqrt(n/Area)
# The standard error
SE <- 0.26136/(sqrt(n^2/Area))
# Obtain the Z value
z <- (Observed-Expected)/SE
# Get the p-value
p.val <- pnorm(z, lower.tail = T)
NN_Mean_Distance_DF <- round(data.frame(Area, Observed, Expected, z, p.val), 4)

