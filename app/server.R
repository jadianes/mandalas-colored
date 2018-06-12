library(shiny)
library(tidyverse)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Stores the ggplot object of each mandala
  mandalas <- list()
  # Stores the parameters of each mandala
  mandalas_params <- data.frame(id=c(), iter=c(), radius=c(), points=c(), palette=c())
  
  # Add new mandala action button
  num_mandalas <- eventReactive(input$add_mandala, {
    i <- nrow(mandalas_params) + 1
    
    # Add new params
    mandalas_params <<- mandalas_params %>% bind_rows( 
      data.frame(
        id = i,
        iter = input$iter,
        radius = input$radius,
        points = input$points
      )
    )
    
    # Reactive blocs to render mandalas
    # NOTE: Make this a reactive bloc when adding individual edit controls
    mandalas[[i]] <<- getMandala(input$iter, input$radius, input$points, input$palette_id)
    
    # Mandalas plots, using each reactive mandala generator
    output[[paste0("distPlot", i)]] <- renderPlot({
      if (is.null(mandalas[[i]])) {
        return(NULL)
      }
      mandalas[[i]]
    })
    
    # Downloadable mandala
    output[[paste0("download_mandala", i)]] <- downloadHandler(
      filename = "mandala.png",
      content = function(file) {
        device <- function(..., width, height) {
          grDevices::png(..., width = width, height = height,
                         res = 300, units = "in")
        }
        ggsave(file, 
               plot = mandalas[[i]],
               height=10, 
               width=10, 
               units='in', 
               dpi=300)
      }
    )
    
    # Return number of mandalas being edited
    nrow(mandalas_params)
  })
  
  # For each mandala being edited...
  observe({
    num_mandalas <- num_mandalas()
    # Create editors
    output$mandala_editors <- renderUI({
      lapply(1:num_mandalas,
         function(i) {
           box(width=4,
            plotOutput(paste0("distPlot",i)),
            downloadButton(paste0("download_mandala",i), "Download")
           )
         }
      )
    }) 
    
    
  })
  
  
  
  
  
  
})
