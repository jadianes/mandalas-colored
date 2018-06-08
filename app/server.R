library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  mandalaPlot <- reactive({
    getMandala(input$iter, input$radius, input$points)
  })
  
  output$distPlot <- renderPlot({
    if (is.null(mandalaPlot())) {
      return(NULL)
    }
    
    mandalaPlot()
  })
  
  # Downloadable mandala
  output$download_mandala <- downloadHandler(
    filename = "mandala.png",
    content = function(file) {
      device <- function(..., width, height) {
        grDevices::png(..., width = width, height = height,
                       res = 300, units = "in")
        }
      ggsave(file, 
             plot = mandalaPlot(),
             height=10, 
             width=10, 
             units='in', 
             dpi=300)
    }
  )
  
})
