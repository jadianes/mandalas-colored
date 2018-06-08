sidebar <- dashboardSidebar(
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
)