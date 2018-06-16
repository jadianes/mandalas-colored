library(shiny)
library(tidyverse)
library(promises)
library(future)
plan(multiprocess)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Stores the ggplot object of each mandala
  mandalas <- list()
  # Stores the parameters of each mandala
  mandalas_params <- data.frame(id=c(), 
                                iter=c(), 
                                radius=c(), 
                                points=c(), 
                                palette_id=c())
  
  # Add new mandala action button
  num_mandalas <- eventReactive(input$add_mandala, {
    i <- nrow(mandalas_params) + 1
    
    # Get input values
    iter <- input$iter
    radius <- input$radius
    points <- input$points
    # Get palette by id or random one
    palette <- getPalette(input$palette_id)
    palette_id <- palette$id
    
    # Add new params
    mandalas_params <<- mandalas_params %>% bind_rows( 
      data.frame(
        id = as.character(i),
        iter = iter,
        radius = radius,
        points = points,
        palette_id = palette_id
      )
    ) %>% mutate(
      palette_id = as.character(palette_id)
    )
    
    # Render mandala params
    output[[paste0("mandala_params", i)]] <- renderTable({
      mandalas_params[mandalas_params$id==i,] %>% select(
        Iterations=iter,
        Radius=radius,
        Points=points,
        Palette=palette_id
      )
    })
    
    # Get mandala, asynchronously
    mandalas[[i]] <- reactive({
      future({
        getMandala(iter, radius, points, palette)
      }) %...>% {
        # Download handler needs to be set here - ggsave doesn't play
        # well with reactive objects assigned to plot
        output[[paste0("download_mandala", i)]] <- downloadHandler(
          filename = "mandala.png",
          content = function(file) {
            device <- function(..., width, height) {
              grDevices::png(..., width = width, height = height,
                             res = 300, units = "in")
            }
            ggsave(file, 
                   plot = .,
                   height=10, 
                   width=10, 
                   units='in', 
                   dpi=360)
          }
        )
        
        # Return mandala plot
        .
      }
    })
    
    output[[paste0("mandala_plot", i)]] <- renderPlot({
      mandalas[[i]]()   
    })

    # Return number of mandalas being edited
    nrow(mandalas_params)
  })
  
  # For each mandala being edited...
  observe({
    num_mandalas <- num_mandalas()
    # Create editors
    output$mandala_editors <- renderUI({
      lapply(1:num_mandalas, getMandalaBox)
    }) 
  })
  
  
})
