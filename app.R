library(shiny)
library(bslib)
library(shinyvalidate)

generate_story <- function(noun, verb, adjective, adverb) {
  glue::glue(
    "Once upon a time, there was a {adjective} {noun} who loved to {verb} {adverb}. 
    One day, while {verb}ing through the forest, the {noun} discovered a magical 
    {adjective} treasure that granted wishes. It was the most {adjective} day ever!"
  )
}

ui <- page_fluid(
  theme = bs_theme(bootswatch = "flatly"),
  titlePanel("Mad Libs Game"),
  
  layout_sidebar(
    sidebar = sidebar(
      textInput("noun1", "Enter a noun:", placeholder = "cat"),
      textInput("verb", "Enter a verb:", placeholder = "dance"),
      textInput("adjective", "Enter an adjective:", placeholder = "funny"),
      textInput("adverb", "Enter an adverb:", placeholder = "quickly")
    ),
    
    card(
      card_header("Your Mad Libs Story"),
      card_body(
        textOutput("story")
      )
    )
  )
)

server <- function(input, output) {
  # Input validation
  iv <- shinyvalidate::InputValidator$new()
  iv$add_rule("noun1", shinyvalidate::sv_required())
  iv$add_rule("verb", shinyvalidate::sv_required())
  iv$add_rule("adjective", shinyvalidate::sv_required())
  iv$add_rule("adverb", shinyvalidate::sv_required())
  iv$enable()
  
  # Live updating story
  output$story <- renderText({
    if (iv$is_valid()) {
      generate_story(input$noun1, input$verb, input$adjective, input$adverb)
    } else {
      "Fill in all the fields to see your story!"
    }
  })
}

shinyApp(ui = ui, server = server)