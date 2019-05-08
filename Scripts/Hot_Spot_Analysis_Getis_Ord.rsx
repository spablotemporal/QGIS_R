##Spatial Statistics Tools = group
##Layer=vector
##Field=Field Layer
##Queen_Contiguity = boolean False
##Fixed_Distance_Band = boolean False
##Distance_Band = number
##HotSpots_Gi = output vector

library(spdep)
n <- length(Layer)
if(Queen_Contiguity == T){
    wnb <- poly2nb(Layer, queen = T)
    wl <- nb2listw(wnb, style = "B")
    # Get number of Nighbors:
    wm <- nb2mat(wnb, style = "B")
    Layer$Neighbors <- rowSums(wm)
} else if(Fixed_Distance_Band == T){
    wnb <- spdep::dnearneigh(coordinates(Layer), d1 = 0, d2 = Distance_Band)
    Layer$Neighbors <- vector(length = n)
    for(i in 1:n){
        Layer$Neighbors[i] <- length(wnb[[i]][wnb[[i]] !=0])
    }
    wl <- nb2listw(wnb, style = "B", zero.policy = T)
}


# For G* we must include each polygon as its own neighbor:
ws <- include.self(wnb)
wls <- nb2listw(ws, style = "B")
wm <- nb2mat(ws, style = "B")
Layer$Neighbors <- rowSums(wm)
Gi <- localG(Layer[[Field]], wls)
# COnvert the output as a vector
Layer$Gi <- as.vector(Gi)
# Get the pvalue
Layer$pval <- 2* pnorm(abs(Gi), lower.tail = F)
# GiDF <- data.frame(Neighbors, Gi, pval)
Layer$Gi_Bin <- vector(length = n)



Layer[which(Layer$pval <= 0.1 & Layer$Gi > 0), "Gi_Bin"] <- 1
Layer[which(Layer$pval <= 0.1 & Layer$Gi < 0), "Gi_Bin"] <- -1
Layer[which(Layer$pval <= 0.05  & Layer$Gi > 0), "Gi_Bin"] <- 2
Layer[which(Layer$pval <= 0.05 & Layer$Gi < 0), "Gi_Bin"] <- -2
Layer[which(Layer$pval <= 0.01  & Layer$Gi > 0), "Gi_Bin"] <- 3
Layer[which(Layer$pval <= 0.01 & Layer$Gi < 0), "Gi_Bin"] <- -3
HotSpots_Gi <- Layer[, c("Gi", "pval", "Gi_Bin")]