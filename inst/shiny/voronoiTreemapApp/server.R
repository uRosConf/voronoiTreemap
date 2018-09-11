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

  showPlotBtn <- reactive({
    if (cur_lev1()!="" & cur_lev2()!="" & cur_lev3()!="" & cur_colorvar()!="" & cur_weightvar()!="" & cur_codesvar()!="") {
      return(TRUE)
    } else {
      return(FALSE)
    }
  })

  observe({
    if (showPlotBtn()) {
      shinyjs::show("row_btn_plot")
    } else {
      shinyjs::hide("row_btn_plot")
    }
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
      shinyjs::hide("row_error")
      shinyjs::html(id="name_of_dataset", html=val)
    }

    cur_lev1("")
    cur_lev2("")
    cur_lev3("")
    cur_colorvar("")
    cur_weightvar("")
    cur_codesvar("")
    available_vars("")
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
    cur_lev1(as.character(input$sel_level1))
  })
  observeEvent(input$sel_level2, {
    cur_lev2(as.character(input$sel_level2))
  })
  observeEvent(input$sel_level3, {
    cur_lev3(as.character(input$sel_level3))
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

    shinyjs::hide("row_error")
  })

  output$curdatadf <- DT::renderDataTable({
    DT::datatable(curdata(),
      options = list(lengthMenu = c(5, 30, 50), pageLength = 5, searching=FALSE))
  })

  observeEvent(input$btn_plot, {
    shinyjs::hide("row_table")
    shinyjs::show("row_btn_showtable")
    shinyjs::hide("row_btn_plot")
    shinyjs::show("row_plot")
  })

  observeEvent(input$btn_showtable, {
    shinyjs::show("row_table")
    shinyjs::hide("row_btn_showtable")
    shinyjs::show("row_btn_plot")
    shinyjs::hide("row_plot")
    shinyjs::hide("row_error")
  })

  output$vt <- render_vt_d3({
    df <- curdata()
    if (nrow(df)==0) {
      return(NULL)
    }

    if (showPlotBtn()==FALSE) {
      shinyjs::show("row_table")
      shinyjs::hide("row_btn_showtable")

      return(NULL)
    }



    out <- data.frame(h1=as.character(df[[cur_lev1()]]))
    out$h2 <- as.character(df[[cur_lev2()]])
    out$h3 <- as.character(df[[cur_lev3()]])
    out$color <- as.character(df[[cur_colorvar()]])
    out$weight <- df[[cur_weightvar()]]
    out$codes <- as.character(df[[cur_codesvar()]])

    #replace nas
    ii <- which(is.na(out$codes))
    legend <- FALSE
    #if (length(ii)>0) {
    #  legend <- FALSE
    #} else {
    #  legend <- TRUE
    #}

    d <-  try(vt_input_from_df(out, scaleToPerc=input$scaleToPerc), silent=TRUE)
    if ("try-error" %in% class(d)) {
      shinyjs::show("row_error")
      cur_lev1 <- reactiveVal("")
      cur_lev2 <- reactiveVal("")
      cur_lev3 <- reactiveVal("")
      cur_colorvar <- reactiveVal("")
      cur_weightvar <- reactiveVal("")
      cur_codesvar <- reactiveVal("")

      updateSelectInput(session, "selData", choices=available_datasets())
      updateSelectInput(session, "sel_level2", choices=c("", available_vars()))
      updateSelectInput(session, "sel_level3", choices=c("", available_vars()))
      updateSelectInput(session, "sel_color", choices=c("", available_vars()))
      updateSelectInput(session, "sel_weight", choices=c("", available_vars()))
      updateSelectInput(session, "sel_codes", choices=c("", available_vars()))
      return(NULL)
    } else {
      shinyjs::hide("row_error")
      #shinyjs::html("row_plot", "") # clear div
      vt_d3(vt_export_json(d), legend=legend)
    }
  })
}
