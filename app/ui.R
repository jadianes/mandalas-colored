#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

dashboardPage(
  
  dashboardHeader(title = "Mandalas Studio", 
                  tags$li(class="dropdown", 
                          tags$a(href="https://github.com/jadianes/mandalas-colored/tree/shiny/app", 
                          icon("github"), "Source", target="_blank"))
                  ), 
  
  dashboardSidebar(
    sidebarMenu(
      menuItem(sliderInput("iter",
                           "Number of iterations:",
                           min = 3,
                           max = 5,
                           value = 3)),
      menuItem(sliderInput("radius",
                           "Radius:",
                           min = 1.02,
                           max = 1.9,
                           value = 1.5)),
      menuItem(sliderInput("points",
                           "Number of points:",
                           min = 4,
                           max = 16,
                           value = 10)),
      menuItem(textInput(
        "palette_id",
        "Colour Lovers palette id (empty for random)"
      )),
      menuItem(actionButton("add_mandala", "Add"))
    )
  ), 
  
  dashboardBody(
    fluidRow(
      uiOutput('mandala_editors')
    )
  )
)
