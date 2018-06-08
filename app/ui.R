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
  dashboardHeader(title = "Mandalas generator"),
  dashboardSidebar(
    sidebarMenu(
      menuItem(sliderInput("iter",
                   "Number of iterations:",
                   min = 3,
                   max = 20,
                   value = 4)),
      menuItem(sliderInput("radius",
                   "Radius:",
                   min = 1.02,
                   max = 1.9,
                   value = 1.5)),
       menuItem(sliderInput("points",
           "Number of points:",
           min = 4,
           max = 20,
           value = 6))
      )
    ),
    
    # Show a plot of the generated distribution
  dashboardBody(
    box(plotOutput("distPlot", height = "400", width = "400"),
    downloadButton("download_mandala", "Download"))
  )
)

