# Average Nearest Neighbor

**This tool provides an Average Nearest Neighbor Mean distance data frame** 

The input parameters are:  
* *Layer:* Must be a point data layer with some values.  
* *Area:* Must be a polygon layer, which will be used to define the study area.  

<img src="Images/ANN01.png" alt="Img01"/>

The output will be a data frame with the columns:  
* *Area:* Size of the study area in <img src="https://latex.codecogs.com/gif.latex?m^2"/>.  
* *Observed:* The average distance for the nearest neighbor of the observations.  
* *Expected:* The expected average distance for the nearest neighbor. For this calculation we use the formula: <img src="https://latex.codecogs.com/gif.latex?\bar{D}_E=\frac{0.5}{\sqrt{n/A}}"/>, where A is the area of the polygon shape provided  
* *z:* Th Z value. We use the formula: <img src="https://latex.codecogs.com/gif.latex?z=\frac{\bar{D}_O-\bar{D}_E}{SE}"/>, where $\bar{D}_O$ is the observed average of nearest neighbor, $\bar{D}_E$ is the expected average of nearest neighbor, and the SE is calculated $SE=\frac{0.26136}{\sqrt{n^2/A}}$.   
* *p.val:* The p-value.  


### [Go Back](../../Readme.md)
