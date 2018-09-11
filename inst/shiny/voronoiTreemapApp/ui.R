# Define UI for application that draws a histogram
ui <- navbarPage("Voronoi-Diagramm",
  tabPanel("Data",
    shinyjs::useShinyjs(),
    fluidRow(
      column(6, selectInput("selData", label="Select Dataframe",
          choices=c("ExampleGDP","canada"))),
      column(6, p(id="name_of_dataset", ""))
    ),
    fluidRow(
      column(12, DT::dataTableOutput("curdatadf"))
    )
  ),
  tabPanel("Plot",
    fluidRow(column(12, h1("The Plot"))),
    fluidRow(column(12, vt_d3_output("vt")))
  )
)
