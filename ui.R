library(shiny)

shinyUI(pageWithSidebar(
        headerPanel("Lower secondary completion rate in the world"),
        sidebarPanel(
                sliderInput(
                        'year',
                        'Choose year*',
                        value = 1971,
                        min = 1971,
                        max = 2013,
                        step = 1
                ),
                h4('*Please wait until the map shows up. It may take up to one minute for the first time.')
        ),
        mainPanel(
                plotOutput("educMap")
        )
))
