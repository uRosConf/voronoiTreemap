server <- function(session, input, output) {
  curdata <- reactiveVal({NULL})

  cur_lev1 <- reactiveVal("")
  cur_lev2 <- reactiveVal("")
  cur_lev3 <- reactiveVal("")
  cur_colorvar <- reactiveVal("")
  cur_weightvar <- reactiveVal("")
  cur_codesvar <- reactiveVal("")
  available_vars <- reactiveVal("")

  vnames <- reactive({
    colnames(curdata())
  })

  observe({
    cn <- setdiff(vnames(), c(cur_colorvar(), cur_weightvar(), cur_codesvar(), cur_lev1(), cur_lev2(), cur_lev3()))
    available_vars(cn)
  })

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

    allv <- available_vars()
    updateSelectInput(session, "sel_level1", choices=allv)
    updateSelectInput(session, "sel_level2", choices=setdiff(allv, input$sel_level1))
    updateSelectInput(session, "sel_level3", choices=setdiff(allv, c(input$sel_level1, input$sel_level2)))
    updateSelectInput(session, "sel_color",  choices=setdiff(allv, c(input$sel_level1, input$sel_level2, input$level3)))
    updateSelectInput(session, "sel_weight", choices=setdiff(allv, c(input$sel_level1, input$sel_level2, input$level3, input$sel_color)))
    updateSelectInput(session, "sel_codes",  choices=setdiff(allv, c(input$sel_level1, input$sel_level2, input$level3, input$sel_color, input$sel_weight)))


  })

  observe({
    updateSelectInput(session, "sel_level1", choices=c(cur_lev1(), available_vars()))
  }, priority=1)
  observe({
    updateSelectInput(session, "sel_level2", choices=c(cur_lev2(), available_vars()))
  }, priority=2)
  observe({
    updateSelectInput(session, "sel_level3", choices=c(cur_lev3(), available_vars()))
  }, priority=3)
  observe({
    updateSelectInput(session, "sel_color", choices=c(cur_colorvar(), available_vars()))
  }, priority=4)
  observe({
    updateSelectInput(session, "sel_weight", choices=c(cur_weightvar(), available_vars()))
  }, priority=5)
  observe({
    updateSelectInput(session, "sel_codes", choices=c(cur_codesvar(), available_vars()))
  }, priority=6)

  observeEvent(input$sel_level1, {
    cur_lev1(input$sel_level1)
  })
  observeEvent(input$sel_level2, {
    cur_lev2(input$sel_level2)
  })
  observeEvent(input$sel_level3, {
    cur_lev3(input$sel_level3)
  })

  observeEvent(input$sel_color, {
    cur_colorvar(input$sel_color)
  })
  observeEvent(input$sel_weight, {
    cur_weightvar(input$sel_weight)
  })
  observeEvent(input$sel_codes, {
    cur_codesvar(input$sel_codes)
  })

  observeEvent(input$btn_reset, {
    cur_lev1 <- reactiveVal("")
    cur_lev2 <- reactiveVal("")
    cur_lev3 <- reactiveVal("")
    cur_colorvar <- reactiveVal("")
    cur_weightvar <- reactiveVal("")
    cur_codesvar <- reactiveVal("")

    updateSelectInput(session, "sel_level1", choices=c("", available_vars()))
    updateSelectInput(session, "sel_level2", choices=c("", available_vars()))
    updateSelectInput(session, "sel_level3", choices=c("", available_vars()))
    updateSelectInput(session, "sel_color", choices=c("", available_vars()))
    updateSelectInput(session, "sel_weight", choices=c("", available_vars()))
    updateSelectInput(session, "sel_codes", choices=c("", available_vars()))
  })


  output$curdatadf <- renderDataTable({
    DT::datatable(curdata(),
      options = list(lengthMenu = c(5, 30, 50), pageLength = 5, searching=FALSE))
  })

  output$vt <- render_vt_d3({
    d <- vt_export_json(vt_input_from_df(curdata()))
    vt_d3(d)
  })

}
