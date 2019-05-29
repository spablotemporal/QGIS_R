##Spatial Statistics Tools = group
##Layer=vector
##Add_Points = boolean False
##Rooks = boolean False
##Neigbors = output vector
##Pts_Nb = output vector

library(spdep)

if(Rooks == T){
    Nb <- poly2nb(Layer, queen = F)
} else {
    Nb <- poly2nb(Layer, queen = T)
}

if(Add_Points == T){
    N <- vector()
    Nbs <- vector()
    for(i in 1:length(Layer)){
        N <-  c(N, length(Nb[[i]]))
        Nbs <- c(Nbs, paste(Nb[[i]], collapse = ", "))
    }
   NbDF <- data.frame(N_Neighbors = N, Neighbors = Nbs)
    Pts_Nb <- SpatialPointsDataFrame(coords = coordinates(Layer), data = NbDF, proj4string = Layer@proj4string)
    
} else {
    Pts_Nb <- NA
}






Neigbors <- nb2lines(Nb, coords = coordinates(Layer), proj4string = Layer@proj4string)

