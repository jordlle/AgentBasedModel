#Creation of a map (named SimMap). It is a list of 2 matrixes with [[1]] being human populations and [[2]] being zombie populations
CreateMap <- function(x, y){
  Humap <- matrix(0, y, x)
  Zomap <- matrix(0, y, x)
  SimMap <- list(Humap, Zomap)
  return(SimMap)
}
#A Function that randomly populates the map with the max number of zombies and humans being passed to the function.
PopulateMap <- function(zomMax, humMax, SimMap){
  for(cell in 1:length(SimMap[[1]])){
    SimMap[[1]][cell] <- floor(runif(1, min=0, max=humMax))
    SimMap[[2]][cell] <- floor(runif(1, min=0, max=zomMax))
  }
  return(SimMap)
}
#This is a function that will randomly populate humans up to the number given to the function and randomly place 1 zombie in one cell
OneZomRand <- function(humMax, SimMap){
  for(cell in 1:length(SimMap[[1]])){
    SimMap[[1]][cell] <- floor(runif(1, min=0, max=humMax))
  }
  row <- floor(runif(1, min=1, max=nrow(SimMap[[1]])))
  col <- floor(runif(1, min=1, max=ncol(SimMap[[1]])))
  SimMap[[2]][row,col] <- 1
  return(SimMap)
}
#This is the first of our 2 update functions that runs at each time step. It will determine how many zombies 1 zombie can create based on a base 10 log function within each cell of the matrix.
InfectMap <- function(SimMap){
  for(cells in 1:length(SimMap[[1]])){
    #This function divides the human population by 100 and tells how many zombies one zombie can make
    #TODO change to a log function for slower growth
    if(as.numeric(SimMap[[1]][cells]) > 100 ){
      zomNum <- floor(log10(as.numeric(SimMap[[1]][cells])))-1
    }
    else{
      zomNum <- 1
    }
    #Multiply the number of how many zombies there is by the zomNum
    infected <- zomNum*as.numeric(SimMap[[2]][cells])
    
    #If humans outnumber creation of new zombies, subtract new zombies from human population
    if(infected < as.numeric(SimMap[[1]][cells])){
      SimMap[[1]][cells] <- as.numeric(SimMap[[1]][cells])-infected
      SimMap[[2]][cells] <- as.numeric(SimMap[[2]][cells])+infected
    }
    #Otherwise just infect the remaining humans in the cell
    else{
      SimMap[[2]][cells] <- as.numeric(SimMap[[2]][cells])+as.numeric(SimMap[[1]][cells])
      SimMap[[1]][cells] <- as.numeric(SimMap[[1]][cells])-as.numeric(SimMap[[1]][cells])
    }
  }
  return(SimMap)
}
#Loop through the SimMaps to turn all cells back to 0
ClearMap <- function(SimMap){
  for (cells in 1:length(SimMap[[1]])){
    SimMap[[1]][cells] <- 0
    SimMap[[2]][cells] <- 0
    
  }
  return(SimMap)
}
#This function will have a small random number of zombies migrate from higher density areas to lower density areas.
SpreadMap <- function(SimMap){
  #Using rows and columns to loop through the matrix so we can determine where the edges of the map are
  for(row in 1:nrow(SimMap[[1]])){
    for(col in 1:ncol(SimMap[[1]])){
      #Checking to the right of a cell, will fail if there are less than 10 zombies or in the rightmost column
      if(col != ncol(SimMap[[1]]) & as.numeric(SimMap[[2]][row,col]) > 10 ){
        #If the cell to the right has less zombies, no new zombies will migrate there
        #If there is less zombies, then a random number between 1 and 10 will be chosen and that many zombies from the original cell will move right
        if(as.numeric(SimMap[[2]][row,col] > as.numeric(SimMap[[2]][row,(col+1)]))){
          zomMove <- floor(runif(1, min=0, max=10))
          SimMap[[2]][row,col] <- as.numeric(SimMap[[2]][row, col]) - zomMove
          SimMap[[2]][row,(col+1)] <- as.numeric(SimMap[[2]][row,(col+1)]) + zomMove
        }
      }
      #Checking to the left of a cell, will fail if there are less than 10 zombies or in the leftmost column
      if(col != 1 & as.numeric(SimMap[[2]][row,col]) > 10 ){
        #If the cell to the right has less zombies, no new zombies will migrate there
        #If there is less zombies, then a random number between 1 and 10 will be chosen and that many zombies from the original cell will move right
        if(as.numeric(SimMap[[2]][row,col] > as.numeric(SimMap[[2]][row,(col-1)]))){
          zomMove <- floor(runif(1, min=0, max=10))
          SimMap[[2]][row,col] <- as.numeric(SimMap[[2]][row, col]) - zomMove
          SimMap[[2]][row,(col-1)] <- as.numeric(SimMap[[2]][row,(col-1)]) + zomMove
        }
      }
      #Checking above a cell, will fail if there are less than 10 zombies or in the first row
      if(row != 1 & as.numeric(SimMap[[2]][row,col]) > 10 ){
        #If the cell to the right has less zombies, no new zombies will migrate there
        #If there is less zombies, then a random number between 1 and 10 will be chosen and that many zombies from the original cell will move right
        if(as.numeric(SimMap[[2]][row,col] > as.numeric(SimMap[[2]][(row-1),col]))){
          zomMove <- floor(runif(1, min=0, max=10))
          SimMap[[2]][row,col] <- as.numeric(SimMap[[2]][row, col]) - zomMove
          SimMap[[2]][(row-1),col] <- as.numeric(SimMap[[2]][(row-1),col]) + zomMove
        }
      }
      #Checking below a cell, will fail if there are less than 10 zombies or in the last row
      if(row != nrow(SimMap[[1]]) & as.numeric(SimMap[[2]][row,col]) > 10 ){
        #If the cell to the right has less zombies, no new zombies will migrate there
        #If there is less zombies, then a random number between 1 and 10 will be chosen and that many zombies from the original cell will move right
        if(as.numeric(SimMap[[2]][row,col] > as.numeric(SimMap[[2]][(row+1),col]))){
          zomMove <- floor(runif(1, min=0, max=10))
          SimMap[[2]][row,col] <- as.numeric(SimMap[[2]][row, col]) - zomMove
          SimMap[[2]][(row+1),col] <- as.numeric(SimMap[[2]][(row+1),col]) + zomMove
        }
      }
    }
  }
  return(SimMap)
}
#This is a meta function that will create the SimMap and populate it with either 1 zombie in one cell or one zombie in multiple cells
CreateModel <- function(x, y, humMax, oneZom){
  SimMap <- CreateMap(x,y)
  if(oneZom == TRUE){
    SimMap <- OneZomRand(humMax, SimMap)
  }
  else{
    SimMap <- PopulateMap(2,humMax, SimMap)
  }
  return(SimMap)
}
#This is the function that loops through all of the time steps and will finish when all humans have been turned
SimulateModel <- function(SimMap){
  run <- TRUE
  dir_out <- file.path(tempdir(), "zoms")
  if(file.exists(dir_out)){
    unlink(dir_out,recursive = TRUE)
  }
  dir.create(dir_out, recursive = TRUE)
  countLoops <- 1
  while(run == TRUE){
    totalHum <- 0
    SimMap <- InfectMap(SimMap)
    SimMap <- SpreadMap(SimMap)
    
    #ggplot gaphing
    a <- arrayInd(1:length(SimMap[[1]]), dim(SimMap[[1]]))
    df <- data.frame(x=a[,1], y=a[,2], hum=as.vector(SimMap[[1]]), zom=as.vector(SimMap[[2]]))
    plot <- ggplot(df, aes(x = x, y = y)) +
      geom_raster(aes(fill=hum)) +
      scale_fill_gradient(low = "white", high = "blue", aesthetics = 'fill') +
      geom_point(aes( size = zom), (df)) +
      scale_size_continuous(range = c(0, 9))+
      labs(x="X", y="Y", title="Zombie Takeover") +
      theme_bw() + theme(axis.text.x=element_text(size=9, angle=0, vjust=0.3),
                         axis.text.y=element_text(size=9),
                         plot.title=element_text(size=11))
    
    fp <- file.path(dir_out, paste0(countLoops, ".png"))
    ggsave(plot = plot,
           filename = fp,
           device = "png")
    countLoops <- countLoops + 1
    
    #Stops the loop if the human population reaches 0
    for(cell in 1:length(SimMap[[1]])){
      totalHum <- totalHum + as.numeric(SimMap[[1]][cell])
    }
    if(totalHum == 0){
      run <- FALSE
    }
  }
  ## list file names and read in
  imgs <- list.files(dir_out, full.names = TRUE)
  img_list <- lapply(imgs, image_read)
  
  ## join the images together
  img_joined <- image_join(img_list)
  
  ## animate at 2 frames per second
  img_animated <- image_animate(img_joined, fps = 2)
  
  ## view animated image
  img_animated
  
  ## save to disk
  image_write(image = img_animated,
              path = "zombieTakeover.gif")
  return(SimMap)
}

library(ggplot2)
install.packages("magick")
library(magick)
SimMap <- CreateModel(10, 10, 50000, TRUE)
SimMap <- SimulateModel(SimMap)