server <- function(input, output) {
  curdata <- reactiveVal({NULL})

  observeEvent(input$selData, {
    val <- input$selData
    if (!is.null(val)) {
      if (val=="ExampleGDP") {
        curdata(ExampleGDP)
      } else if (val=="canada") {
        curdata(canada)
      } else {
        curdata(NULL)
      }
      shinyjs::html(id="name_of_dataset", html=val)
    }
  })

  output$curdatadf <- renderDataTable({
    DT::datatable(curdata(),
      options = list(lengthMenu = c(5, 30, 50), pageLength = 5, searching=FALSE))
  })


  output$vt <- render_vt_d3({
    d <- vt_export_json(vt_input_from_df(curdata()))
    vt_d3(d)
    #vt_d3(djson)
  })

}
