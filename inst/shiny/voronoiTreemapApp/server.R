server <- function(input, output) {
  curdata <- reactiveVal({NULL})

  observeEvent(input$selData, {
    val <- input$selData
    if (!is.null(val)) {
      if (val=="ExampleGDP") {
        curdata(ExampleGDP)
      } else {
        df <- data.frame(A=1)
        curdata(df)
      }
      shinyjs::html(id="name_of_dataset", html=val)
    }
  })

  output$curdatadf <- renderDataTable({
    curdata()
  })

  output$vt <- render_vt_d3({
    d <- vt_export_json(vt_input_from_df(curdata()))
    vt_d3(d)
    #vt_d3(djson)
  })

}
