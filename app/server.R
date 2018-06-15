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
    palette_id <- input$palette_id
    print(paste("Palette id is ", palette_id))
    
    # Add new params
    mandalas_params <<- mandalas_params %>% bind_rows( 
      data.frame(
        id = as.character(i),
        iter = iter,
        radius = radius,
        points = points,
        palette_id = ifelse(is.null(palette_id), "", palette_id)
      )
    ) %>% mutate(
      palette_id = as.character(palette_id)
    )
    
    # Get mandala, asynchronously
    output[[paste0("mandala_plot", i)]] <- renderPlot({
      future({
        getMandala(iter, radius, points, palette_id)
      }) %...>% {
        mandalas[[i]] <<- .$plot
        print(paste("Palette id is", .$palette_id))
        mandalas_params[i,"palette_id"] <<- .$palette_id
        print(paste("Palette id is", mandalas_params[i,c("palette_id")]))
        .$plot
      }
    })
    
    # Mandala params
    output[[paste0("mandala_params", i)]] <- renderTable({
      mandalas_params[mandalas_params$id==i,] %>% select(
        Iterations=iter,
        Radius=radius,
        Points=points,
        Palette=palette_id
      )
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
    
    print("Done with event")
    # Return number of mandalas being edited
    nrow(mandalas_params)
  })
  
  # For each mandala being edited...
  observe({
    print("Starting to observe")
    num_mandalas <- num_mandalas()
    # Create editors
    output$mandala_editors <- renderUI({
      lapply(1:num_mandalas,
         function(i) {
           box(width=4,
            plotOutput(paste0("mandala_plot",i)),
            tableOutput(paste0("mandala_params",i)),
            downloadButton(paste0("download_mandala",i), "Download")
           )
         }
      )
    }) 
  })
  
})
