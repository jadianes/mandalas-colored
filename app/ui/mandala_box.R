getMandalaBox <- function(i) {
  box(width=6,
      plotOutput(paste0("mandala_plot",i)),
      tableOutput(paste0("mandala_params",i)),
      downloadButton(paste0("download_mandala",i), "Download")
  )
}