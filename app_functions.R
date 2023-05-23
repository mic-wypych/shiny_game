get_game_grid <- function(nrow, ncol, n_walls, debug = FALSE) {
  
  game_grid <- matrix(rep('-', nrow*ncol), nrow = nrow, ncol = ncol)
  
  #2 define target coordinates
  obj_x <- sample(1:nrow, 1)
  obj_y <- sample(1:ncol, 1)
  target_coord <- c(obj_x, obj_y)
  
  
  #3define start coordinates
  get_start_coord <- function() {
    start_x <- sample(1:nrow, 1)
    start_y <- sample(1:ncol, 1)
    start_coord <- c(start_x, start_y)
    
    #check if start coordinates are not target coordinates
    if (target_coord[1] == start_coord[1] & target_coord[2] == start_coord[2]) {
      get_start_coord()
    }
    return(start_coord)
  }
  
  start_coord <- get_start_coord()
  
  #Create walls
  create_walls <- function() {
    #define walls
    
    #create a grid of all coordinates
    all_coords <- expand.grid(1:nrow, 1:ncol)
    
    walls <- do.call(`rbind`, sample(asplit(all_coords, 1), n_walls))
    
    walls_coords <- split(walls, seq(nrow(walls)))
    
    return(walls_coords)
  }
  
  walls_coords <- create_walls()
  
  #Check if start or target coords are not on a wall
  while((list(target_coord) %in% walls_coords) | (list(start_coord) %in% walls_coords)) {
    walls_coords <- create_walls()
  }
  
  #BFS ALGORITHM TO CHECK IF GAME IS WINNABLE
  is_valid_move <- function(row, col, n, p, visited) {
    # Check if the cell is within the bounds of the matrix
    if (row < 1 || row > n || col < 1 || col > p) {
      return(FALSE)
    }
    
    # Check if the cell has already been visited
    if (visited[row, col]) {
      return(FALSE)
    }
    
    # Check if the cell is valid (i.e., contains "-", "X", or "T")
    if (!(game_grid[row, col] %in% c("-", "X", "T"))) {
      return(FALSE)
    }
    
    # If all conditions are satisfied, the move is valid
    return(TRUE)
  }
  
  # Define the function to find a path between "X" and "T"
  find_path <- function(game_grid) {
    # Define the start and end cells
    start_row <- which(game_grid == "X", arr.ind = TRUE)[1]
    start_col <- which(game_grid == "X", arr.ind = TRUE)[2]
    end_row <- which(game_grid == "T", arr.ind = TRUE)[1]
    end_col <- which(game_grid == "T", arr.ind = TRUE)[2]
    
    # Define the queue and visited matrix
    queue <- list()
    visited <- matrix(FALSE, nrow = nrow(game_grid), ncol = ncol(game_grid))
    
    # Add the start cell to the queue
    queue[[1]] <- c(start_row, start_col, 0)
    
    # Loop until the queue is empty
    while (length(queue) > 0) {
      # Get the first cell in the queue
      curr_cell <- unlist(queue[[1]])
      curr_row <- curr_cell[1]
      curr_col <- curr_cell[2]
      curr_dist <- curr_cell[3]
      
      # Remove the first cell from the queue
      queue <- queue[-1]
      
      # Mark the cell as visited
      visited[curr_row, curr_col] <- TRUE
      
      # Check if the current cell is the end cell
      if (curr_row == end_row && curr_col == end_col) {
        # Return the distance from the start cell to the end cell
        return(curr_dist)
      }
      
      # Check the neighboring cells
      neighbor_cells <- list(c(curr_row - 1, curr_col), c(curr_row + 1, curr_col), 
                             c(curr_row, curr_col - 1), c(curr_row, curr_col + 1))
      for (neighbor_cell in neighbor_cells) {
        neighbor_row <- neighbor_cell[1]
        neighbor_col <- neighbor_cell[2]
        
        if (is_valid_move(neighbor_row, neighbor_col, nrow(game_grid), ncol(game_grid), visited)) {
          # Add the neighboring cell to the queue
          queue[[length(queue) + 1]] <- c(neighbor_row, neighbor_col, curr_dist + 1)
        }
      }
    }
    
    # If no path is found, return FALSE
    return(FALSE)
  }
  #add a check that there exists a path! We'll need the BFS for this
  
  
  #display the first grid and instructions
  #change elements of grid to walls:
  for(i in walls_coords) {
    game_grid[i[1],i[2]] <- '#'
  }
  
  game_grid[start_coord[1], start_coord[2]] <- 'X'
  game_grid[target_coord[1], target_coord[2]] <- 'T'
  
  bfs_result <- find_path(game_grid)
  
  while(!bfs_result) {
    #regenerate walls
    walls_coords <- create_walls()
    game_grid <- matrix(rep('-', nrow*ncol), nrow = nrow, ncol = ncol)
    for(i in walls_coords) {
      game_grid[i[1],i[2]] <- '#'
    }
    
    game_grid[start_coord[1], start_coord[2]] <- 'X'
    game_grid[target_coord[1], target_coord[2]] <- 'T'
    bfs_result <- find_path(game_grid)
    
  }
  
  if(debug == FALSE) {
    game_grid[target_coord[1], target_coord[2]] <- '-'
  }
  
  game_grid[start_coord[1], start_coord[2]] <- '<img src="https://icons.iconarchive.com/icons/custom-icon-design/silky-line-user/256/man-icon.png" style="height:auto; width:auto" />'
  
  
  for(i in walls_coords) {
    game_grid[i[1],i[2]] <- '<img src="https://simg.nicepng.com/png/small/22-227890_brick-wall-bricks-construction-wall-bricks-png.png" style="height:auto; width:auto" />'
  }
  
  #set current coordinates
  current_coord <- start_coord
  
  #calculate distance as Manhattan
  
  old_distance <- sum(abs(target_coord[1] - current_coord[1]),abs(target_coord[2] - current_coord[2]))
  
  #initiate move counter
  
  n_moves <- 1
  
  
  result_list <- list(nrow = nrow, ncol = ncol, game_grid = game_grid, start_coord = start_coord, target_coord = target_coord,
                      current_coord = current_coord, walls_coords= walls_coords, old_distance = old_distance, new_distance = old_distance,
                      n_moves =n_moves)
  
  return(result_list)
}


make_move <- function(h, add, game_state) {
  
  
  #unpack game state
  nrow <- game_state$nrow
  ncol <- game_state$ncol
  start_coord <- game_state$start_coord
  target_coord <- game_state$target_coord
  current_coord <- game_state$current_coord
  old_distance <- game_state$old_distance
  new_distance <- game_state$new_distance
  walls_coords <- game_state$walls_coords
  n_moves <- game_state$n_moves
  game_grid <- game_state$game_grid
  
  
  if (h == 1 & add == 1) {
    if (current_coord[h] + add > nrow) {
      showNotification('You cant move there!')
      return(game_state) # this will force R to move to the next iteration of the loop
    } 
    if (list(as.integer(c(current_coord[1]+ add,current_coord[2] ))) %in% walls_coords) {
      #check if you walk on a wall
      showNotification('You cant move there!')
      return(game_state)
    }
  } else if (h == 1 & add==-1) {
    if (current_coord[h] + add < 1) {
      showNotification('You cant move there!')
      return(game_state) # this will force R to move to the next iteration of the loop
    } 
    if (list(as.integer(c(current_coord[1] + add,current_coord[2]))) %in% walls_coords) {
      #check if you walk on a wall
      showNotification('You cant move there!')
      return(game_state)
    }
    
  } else if (h == 2 & add==1) {
    if (current_coord[h] + add > ncol) {
      showNotification('You cant move there!')
      return(game_state) # this will force R to move to the next iteration of the loop
    } 
    if (list(as.integer(c(current_coord[1],current_coord[2]+ add))) %in% walls_coords) {
      #check if you walk on a wall
      showNotification('You cant move there!')
      return(game_state)
    }
    
  } else if (h == 2 & add==-1) {
    if (current_coord[h] + add < 1) {
      showNotification('You cant move there!')
      return(game_state) # this will force R to move to the next iteration of the loop
    } 
    if (list(as.integer(c(current_coord[1] ,current_coord[2]+ add))) %in% walls_coords) {
      #check if you walk on a wall
      showNotification('You cant move there!')
      return(game_state)
    }
  }
  
  
  #update grid and coords
  game_grid[current_coord[1], current_coord[2]] <- '-'
  current_coord[h] <- current_coord[h] + add
  game_grid[current_coord[1], current_coord[2]] <- '<img src="https://icons.iconarchive.com/icons/custom-icon-design/silky-line-user/256/man-icon.png" style="height:auto; width:auto" />'
  
  #update distance and number of moves
  new_distance <- sum(abs(target_coord[1] - current_coord[1]),abs(target_coord[2] - current_coord[2]))
  n_moves <- n_moves + 1
  
  #display message
  if(new_distance < old_distance) {
    showNotification('Hotter!', type = 'warning')
  } else if (new_distance > old_distance) {
    showNotification('Colder!', type = 'error')
  }
  #update distance
  old_distance <- new_distance
  #print grid and make next move
  
  result_list <- list(nrow = nrow, ncol = ncol, game_grid = game_grid, start_coord = start_coord, target_coord = target_coord,
                                    current_coord = current_coord, old_distance = old_distance, new_distance = old_distance,
                                    n_moves =n_moves, walls_coords = walls_coords)
  
  return(result_list)
  
}