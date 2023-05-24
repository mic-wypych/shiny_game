# TODO

## 1. UI:
	1.1 DONE Sidebar for defining the game: ncol, nrow and nwalls
	1.2 DONE Sidebar button to start the game: it should trigger rendering of the game grid
	1.3 DONE The game grid that will be updated
	1.4 DONE buttons for movements: up, down, left, right
	1.5 DONE message for warmer or colder
	1.6 DONE Welcome message with instructions (or maybe some button to open it?)
	
## 2. Server:
	2.1 DONE  Render the game grid using nwalls, ncol and nrow inputs after the button is pressed; Using all the checks; the function should return also other states of the game (start and target coords, n moves and distances)
	2.2 DONE Define functions for the movements. Each function should run when appropriate button is pressed
	2.3 DONE calculate distances and create output with message
	2.4 DONE Define winning conditions and winning message

## 3. Styling & theming
	3.1 DONE Make the game grid a flex box with buttons appearing under the box
		3.1.1 DONE Make the table adjust to the screen
		3.1.2 DONE Adjust cell size to have fixed size of cells
		3.1.3 Find own/CC images for walls, player and free cells
	3.2 Define fonts that would look good
	3.3 define colors: what color theme would be best?

## 4. Deploy!
	4.1 DONE github it
	4.2 deploy via shinyapps? Netlify?
