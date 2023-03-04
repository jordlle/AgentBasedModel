# AgentBasedModel

### State Space

A map (of user-designated size) will be created with a designated amount of humans and zombies in individual squares. The user will give the function how many rows and columns the space is and will be used to generate a matrix of that size to hold data. The map will be limited to a 2D space. Our goal is to implement importing GIS data to make “realistic” models.

In each cell on the map there will be 2 variables measured: 

1) population of humans 

2) population of zombies

 

### Parameter Space

All measured values will be integers to simplify the model.

1) Zombie Infection Rate (How many humans get infected per zombie during 1 time step). 

    a) This will be determined based on population density within one square (more humans; the more humans get infected by one zombie). Taking the floor of the log(human population) seems to be a pretty good strategy. When the infection rate is 0, there will be a 50/50 chance that a single zombie will infect a single human.

2) Zombie movement rate (A small [random] number of zombies will travel from a square with a higher population of zombies to an adjacent cell with a lower number of zombies)

 
 
### Update Algorithm

Each step will be calculated using our 2 parameters mentioned above in the order shown. For each cell, there will be 2 variables available, the population of humans and the population of zombies. A calculation will be made to determine how many humans one zombie will infect based on the population density (likely a linear equation rounded to the nearest whole number). We then multiply this number by the population of zombies, remove that many individuals from the human population, and add them to the zombie population. Once all cell infection calculations have been completed then the movement will be calculated. 

If we iterate through a matrix in R, then we can check adjacency by adding/subtracting 1 to the current cell ID for left to right and adding/subtracting the number of columns used in the map for up and down adjacency. Cells on the edge (first/last row and column) will have exceptions built in to fail a check if the search goes "out of bounds". When a cell's adjacent cells are checked, there are several conditions that will need to be filled before a zombie can move to it. Does that cell have a lower population of zombies and is that square passable (which will be designated by a matrix of 1's and 0's). If both are true, then a random number will be generated (between 0 and 10) to see how many zombies will be subtracted from that cell and added to the adjacent one. Zombies cannot travel off of the edge of the map since all values are contained within the matrix.
