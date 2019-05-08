##Spatial Statistics Tools = group
##Layer=vector
##Field=Field Layer
##Queen_Contiguity = boolean False
##Fixed_Distance_Band = boolean False
##Distance_Band = number
##N_simulations = number
##Output = output vector
##showplots

library(spdep)
n <- length(Layer)
if(Queen_Contiguity == T){
    wnb <- poly2nb(Layer, queen = T)
    wl <- nb2listw(wnb, style = "B")
    # Get number of Nighbors:
    wm <- nb2mat(wnb, style = "B")
    Layer$Neighbors <- rowSums(wm)
} else if(Fixed_Distance_Band == T){
    wd <- spdep::dnearneigh(coordinates(Layer), d1 = 0, d2 = Distance_Band)
    Layer$Neighbors <- vector(length = n)
    for(i in 1:n){
        Layer$Neighbors[i] <- length(wd[[i]][wd[[i]] !=0])
    }
    wl <- nb2listw(wd, style = "B", zero.policy = T)
}


# Morans i Scatterplot
# manually make a moran plot standardize variables and save to a new
# column
Layer$sVariable <- scale(Layer[[Field]])
# create a lagged variable
Layer$lag <- lag.listw(wl, Layer[[Field]])
plot(x = Layer$sVariable, y = Layer$lag)
abline(h = 0, v = 0)
abline(lm(Layer$lag ~ Layer$sVariable), lty = 3, lwd = 4, col = "red")

# Do local MI with observed data
locm <- localmoran(Layer[[Field]], wl, alternative = "two.sided")
Layer$I <- locm[,1]
Layer$p <- locm[,5]

# Permutations for pseudo p-values
# Create function for pseudo p-values:
Local.MI.MC <- function(Data, N_simulations, wl){
  MI.Test <- data.frame(localmoran(Data, wl))
  I <- MI.Test$Ii
  n <- length(Data)
  #Create 1 x n matrix with each column being a polygon and the first row the I statistic for observed data
  Ii <- t(I)
  # Make a loop for the simulations:
  for(i in 1:N_simulations){
    i <- 1
    # Randomly sample from the observed data
    S <- sample(1:n, n, replace = F)
    # Assign the sampled values randomly to other features:
    DataS <- Data[S]
    # Run a Moran's I for the generated data:
    Iij <- localmoran(DataS, wl)[,1]
    # Add a row for each I calculated for the simulated data
    Ii <- rbind(Ii, Iij)
  }
  # Make a loop for calculating p values:
  p <- vector(length = n)
  # make a for loop for calculating pseudo p-val
  for(i in 1:ncol(Ii)){
    # calculate proportion of simulated Is greater than observed:
    p[i] <-  (sum(abs(Ii[-1,i]) >= abs(I[i]))) / (N_simulations + 1)
  }
  return(p)
}

# Use the function on the data:
pval <- Local.MI.MC(Layer[[Field]], N_simulations, wl)

# Using Pseudo p-val:
# Identify Outliers and clusters:
Layer@data[which((Layer$sVariable >= 0 & Layer$lag >= 0) & (pval <= 0.05)), "COType"] <- "HH"
Layer@data[which((Layer$sVariable <= 0 & Layer$lag <= 0) & (pval <= 0.05)), "COType"] <- "LL"
Layer@data[which((Layer$sVariable >= 0 & Layer$lag <= 0) & (pval <= 0.05)), "COType"] <- "HL"
Layer@data[which((Layer$sVariable <= 0 & Layer$lag >= 0) & (pval <= 0.05)), "COType"] <- "LH"

Output <- Layer[,c("Neighbors", "I", "p", "COType")]