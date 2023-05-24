#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyalert)
library(tableHTML)
library(bslib)
source('app_functions.R')
options(xtable.type = 'html')
includeCSS("style.css")
# Define UI for application that draws a histogram
ui <- fluidPage(
    # Application title
    titlePanel("Hot and cold"),
    tags$link(rel ="stylesheet",type="text/css", href="style.css"),
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            numericInput("nrow", "Number of rows", value = 5, min = 0, max = 20),
            numericInput("ncol", "Number of columns", value = 5, min = 0, max = 20),
            numericInput("walls", "Number of walls", value = 1, min = 0, max = 50),
            actionButton("play", "PLAY!", class = "btn-lg btn-success")
        ),

        # Show a plot of the generated distribution
        mainPanel(fluidRow(
          tableOutput("matrix"),
          tags$head(tags$style(type = "text/css", "#matrix th {display:none;}"))
          ),
        mainPanel(
            actionButton("left", "LEFT", class = "btn-lg btn-success"),
            actionButton("up", "UP", class = "btn-lg btn-success"),
            actionButton("down", "DOWN", class = "btn-lg btn-success"),
            actionButton("right", "RIGHT", class = "btn-lg btn-success")
          ) #remove columns names
        
           
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  #Welcome message and rules
  shinyalert("Welcome", "Hey hi hello! This is a hot & cold game\nThe rules are:
             You have to find the treasure. You can move by pressing
             up, down, left or right. X shows your current position
             You cant walk over walls which are shown with #
             after each move the game will tell you if you are getting
             closer (Hot) or further (cold)", type = "info")
  
  #initialize game when play pressed
  observeEvent(input$play, {
    game_state <<- get_game_grid(input$nrow, input$ncol, input$walls)
    current_coord <<- game_state$current_coord
    output$matrix <- renderTable({
      game_grid <- game_state$game_grid 
    }, sanitize.text.function = function(x) x, width = "100%")
  })

  #Define movements when buttons are pressed
  observeEvent(input$up, {
    game_state <<- make_move(1,-1, game_state)
    current_coord <<-game_state$current_coord
    target_coord <- game_state$target_coord
    output$matrix <- renderTable({
      game_grid <- game_state$game_grid
    }, sanitize.text.function = function(x) x)
    if ((target_coord[1] == current_coord[1] & target_coord[2] == current_coord[2])) {
      shinyalert(paste0("Congratulations!
                      You found the treasure in", game_state$n_moves, ' moves'),type = "success")
    }
    
  })
    
  observeEvent(input$down, {
    game_state <<- make_move(1,1, game_state)
    current_coord <<- game_state$current_coord
    target_coord <- game_state$target_coord
    output$matrix <- renderTable({
      game_state$game_grid
    }, sanitize.text.function = function(x) x)
    if ((target_coord[1] == current_coord[1] & target_coord[2] == current_coord[2])) {
      shinyalert(paste0("Congratulations!
                      You found the treasure in", game_state$n_moves, ' moves'),type = "success")
    }

  })
  
  observeEvent(input$right, {
    game_state <<- make_move(2,1, game_state)
    current_coord <<-game_state$current_coord
    target_coord <- game_state$target_coord
    output$matrix <- renderTable({
      game_state$game_grid
    }, sanitize.text.function = function(x) x)
    if ((target_coord[1] == current_coord[1] & target_coord[2] == current_coord[2])) {
      shinyalert(paste0("Congratulations!
                      You found the treasure in", game_state$n_moves, ' moves'),type = "success")
    }

  })
  
  observeEvent(input$left, {
    game_state <<- make_move(2,-1, game_state)
    current_coord <<-game_state$current_coord
    target_coord <- game_state$target_coord
    output$matrix <- renderTable({
      game_state$game_grid
    }, sanitize.text.function = function(x) x)
    if ((target_coord[1] == current_coord[1] & target_coord[2] == current_coord[2])) {
      shinyalert(paste0("Congratulations!
                      You found the treasure in ", game_state$n_moves, ' moves'), type = "success")
    }

  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)









