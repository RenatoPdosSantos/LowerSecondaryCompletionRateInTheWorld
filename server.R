library(shiny)
library(broom)
library(reshape2)
library(ggplot2)
library(maptools)
library(rgeos)
library(scales)
library(mapproj)

educData <- read.csv("WDI_Data.csv", header = TRUE)
educData <- educData[educData$Indicator.Code == "SE.PRM.CMPT.ZS", ]
educData$Indicator.Name <- NULL
educData$Indicator.Code <- NULL
educData$X1960 <- NULL
educData$X1961 <- NULL
educData$X1962 <- NULL
educData$X1963 <- NULL
educData$X1964 <- NULL
educData$X1965 <- NULL
educData$X1966 <- NULL
educData$X1967 <- NULL
educData$X1968 <- NULL
educData$X1969 <- NULL
educData$X1970 <- NULL
educData$X2014 <- NULL
educData$X2015 <- NULL
educData$Country.Name <- NULL
names <- educData$Country.Code
educData <- as.data.frame(t(educData[, -1]))
colnames(educData) <- names
educData$year <- as.numeric(substr(row.names(educData), 2, 5))
row.names(educData) <- NULL
educData <-
        melt(educData,
             id.vars = c("year"),
             variable.name = "id")
educData$id <- as.character(educData$id)
educData$rate <- educData$value/100
countries.shp <- readShapeSpatial("TM_WORLD_BORDERS_SIMPL-0.3.shp")
# ISO 3166-1 alpha-3 codes represent countries, dependent territories,
# and special areas of geographical interest 
# (https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3).
countriesDF <- fortify(countries.shp, region = 'ISO3')
countriesDF <- countriesDF[order(countriesDF$order), ]

shinyServer(function(input, output) {
        output$educMap <- renderPlot({
                year <- input$year
                educMap <- ggplot() +
                        geom_map(
                                data = educData[educData$year == year,],
                                aes(map_id = id,
                                    fill = rate),
                                map = countriesDF,
                                color = 'lightgrey'
                        ) +
                        scale_fill_gradient(limits = c(0, 1), 
                                            labels = percent) +
                        expand_limits(x = countriesDF$long,
                                      y = countriesDF$lat) +
                        coord_map() +
                        theme_minimal()
                save.image(".RData")
                print(educMap)
        })
})
