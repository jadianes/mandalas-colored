body <- dashboardBody(
  box(plotOutput("distPlot", height = "400", width = "400"),
      downloadButton("download_mandala", "Download"))
)