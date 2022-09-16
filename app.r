library( shiny )
library( shinydashboard )
library( shinydashboardPlus )
library( skimr )
library( kableExtra )

ui = shinydashboardPlus::dashboardPage(
  
  title = "Test",
  skin = "midnight",
  
  header     = dashboardHeader(),
  controlbar = dashboardControlbar(),
  sidebar    = shinydashboardPlus::dashboardSidebar(
    
    sidebarMenu(
      menuItem("Load Data", tabName = "tab_load", icon = icon("fas fa-upload") ),
      menuItem("Visualise", tabName = "tab_2", icon = icon("circle") )
    )   
  ),
  
  body = dashboardBody(
    
    tabItems(
      
      #--------------------------FILE UPLOAD---------------------------#
      
      tabItem(
        
        tabName = "tab_load",
        "Cuurently under test. Only accepts .csv files at the moment.",

        tags$style(HTML(
          
          " .well { background-color: #272c30;}"
          
        )),
        
        
        
        sidebarLayout(

          sidebarPanel = sidebarPanel(
            width = 3,
            
            selectInput( inputId = "datasets", label = "Datasets", choices = data( package = "datasets")$results[,"Item"], selected = "iris", selectize = F),
            actionButton( inputId = "load_data", label = "Load" ),
            
            tags$hr(),
            
            fileInput("file1", "Choose CSV File",
                      multiple = FALSE,
                      accept = c("text/csv",
                                 
                                 "text/comma-separated-values,text/plain",
                                 
                                 ".csv")),

            # Horizontal line ----
            
            tags$hr(),

            # Input: Select number of rows to display ----
            
            radioButtons("disp", "Display",
                         choices = c(Head = "head",
                                     All = "all"),
                         selected = "head")

          ),
          
          
          
          mainPanel = mainPanel(
            width = 9,
            # wrapping in fluidRow to stop overflow of table output
            column(width = 12, 
                   box( title = "Data", width = NULL, collapsible = TRUE, div(style = 'overflow-x: scroll', tableOutput("contents") ) ),
                   box( title = "Summary", width = NULL, collapsible = TRUE, 
                        
                        fluidRow(
                          column( width = 4,
                                  div(style = 'overflow-x: scroll', tableOutput("summary") ) ),
                          column( width = 4,
                                 div(style = 'overflow-x: scroll', tableOutput("type") ) )
                          
                        )
                   )
                        
                )
          )
        )
      ),
      
      tabItem( tabName = "tab_2", box( title = "A Box!", collapsible = TRUE, verbatimTextOutput("plot") ) )

    )
  ),
  
  footer  = dashboardFooter()

)





server = function(input, output, session) {
  
  data <- eventReactive(input$load_data, {
    
    get( input$datasets )
    
  })
  
  # output$contents <- renderTable({
  #   
  #   if(input$disp == "head") {
  #     return(head(data()))
  #   }
  #   else {
  #     return(data())
  #   }
  #   
  # })
  # 
  output$contents <- function(){
    
    if( input$disp == "head"){
      data_in <- head(data())
    } else {
      data_in <- data()
    }
    
    data_in %>% knitr::kable("html") %>% kable_styling( c("bordered", "hover"), full_width = F, position = "left", font_size = "12")
    
    
  }
  
  
  output$summary <- function(){
    
    tibble( "Number of rows" = nrow(data()), "Number of columns" = ncol(data())) %>% 
      pivot_longer( cols = everything(), names_to = "blah", values_to = "Length") %>% 
      column_to_rownames("blah") %>%
      knitr::kable("html", caption = "Data Dimensions", col.names = c(" ")) %>% 
      kable_styling( full_width = T, position = "left", font_size = "12")
    
  }
  
  output$type <- function(){
    
    tibble( type = sapply( data(), class) ) %>% 
      count(type) %>% 
      column_to_rownames("type") %>%
      knitr::kable("html", caption = "Data Types", col.names = c(" ")) %>% 
      kable_styling( full_width = T, position = "left", font_size = "12")
    
  }
  
  
  
  # output$contents <- renderTable({
  #   
  #   
  #   
  #   # input$file1 will be NULL initially. After the user selects
  #   # and uploads a file, head of that data file by default,
  #   # or all rows if selected, will be shown.
  #   req(input$file1)
  #   
  #   # when reading semicolon separated files,
  #   # having a comma separator causes `read.csv` to error
  #   
  #   tryCatch(
  #     {
  #       df <- read.csv(input$file1$datapath )
  #     },
  #     error = function(e) {
  #       
  #       # return a safeError if a parsing error occurs
  #       stop(safeError(e))
  #     }
  #   )
  # 
  #   if(input$disp == "head") {
  #     return(head(df))
  #   }
  #   else {
  #     return(df)
  #   }
  # 
  # })
  # 
  # 
  
  output$plot <- renderPrint({
    
    #df <- read.csv( input$file1$datapath )
    
    #plot( df[,1], df[,2], type = "p")

    #data() %>% skim() %>% knitr::knit_print( ) %>% knitr::knit()
  })

}

shinyApp(ui = ui, server = server)