# shiny_game
 A simple game of finding a treasure in shiny

## General idea

The idea behind the app is to build a simple labyrinth game in which
the player has to move through a maze to find a hidden treasure based on clues
whether they are getting closer or farther from the goal. The game is played
on a rectangular grid and the player can move in 4 directions: up, down, left or
right. The player can't walk over walls and can't walk off the grid. The goal
is to find the treasure in as few moves as possible.


I think the game was a nice exercise for mew in building the engine, considering
all the potential things that I need to safeguard from and in building simple 
algorithms like breadth first search.
I tried to keep the dependencies to minimum so the game itself is fully
base R. Any packages used are on the shiny side - for building the server or (mainly)
the UI of the game (which is still work in progress)

the app is not yet deployed because the UI is still pretty terrible

## The game itself

The game is based on 2 main functions : `get_game_grid()` and `make_move()`.
The first one is used for defining the starting conditions of the game: generating
the game grid, creating starting and treasure position as well as positions of
the walls. It also performs necessary checks like no overlap of starting and treasure
position and making sure there is a path from start to treasure position.
It also calculates the initial distance (as manhattan without counting in the walls for now,
maybe I'll switch to euclidean) and initiates the move counter.

The `make_move()` function defines possible moves (up,down, left, right), performs
necessary checks (are we walking off the grid? Are wqe walking on a wall?), adjusts
the position, distance and move counter as well as checks if winning conditions are
satisfied.

## UI

Well it ain't really there yet ;)
The idea for now is to make the size of the grid adjustable to the screen & then
to make the general theming of fonts, colors etc.