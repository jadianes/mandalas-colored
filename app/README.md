# Mandalas Studio

This is a Shiny app to interactively generate mandalas using the voronoi tesselation code written by @aschinchon. You can read more about it [at his blog](https://fronkonstin.com/2018/03/11/mandalas-colored/). It allows the user to:  
- Generate multiple mandalas dynamically in the same view and using different parameters, providing an interactive visual exploration tool.  
- Download the results as `PNG` files.  

![The UI](img/screenshot.png?raw=true "The UI")

## Prerequisites  

In addition to those required by the original mandalas code, and those required to run Shiny apps, you will also need to install the following packages (if you don't have them already):

```
install.packages("promises")
install.packages("future")
```

They are used to run R code asynchronously.

## Implementation  

### Functions  

At the core of the Shiny application there is the voronoi tesselation code written by @aschinchon. You can read more about it [at his blog](https://fronkonstin.com/2018/03/11/mandalas-colored/). The code is all contained in the `functions/mandalas.R` script and has been refactored into functions to be called from the Shiny app using parameters, and also to pre-calculate a small part of the data needed to generate the mandala.    
### Dynamic UI  

The UI elements of the Shiny app are genrated on run time. We can generate multiple mandalas with different configurations using the sidebar controls. Each of these mandalas can then be downloaded. Therefore, the following three elements are generated for each click in the `Add` button:  

- The necessary UI elements representing the mandala's `ggplot`, parameters, and `Dowload` button.  
- The `renderPlot` bloc that displays the mandala.  
- The `Download` button haldler.  

Al of them are kept into dynamic data structures and the code associated with them is kept in the `ui` folder as functions called (typically) from `server.R` based on events.    

### Async programming 

The mandala generation code is called asynchronously using the `promises` and `future` packages. By doing so, we can achieve certain improved responsiveness and a better overall user experience. A first introduction to async programming with Shiny can be [found here](https://rstudio.github.io/promises/articles/shiny.html).  

## Authors

### Mandalas generation  

Antonio Sánchez Chinchón - @aschinchon

### Shiny app  

Jose A. Dianes - @jadianes  


