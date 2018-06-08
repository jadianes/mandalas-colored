body <- dashboardBody(
  lapply(1:2,
    function(i) {
      box(plotOutput(paste0("distPlot",i), height = "400", width = "400"),
      downloadButton(paste0("download_mandala",i), paste0("Download",i)))
    }
  )
)