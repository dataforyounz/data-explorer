
ui = shinydashboardPlus::dashboardPage(
  
  title = "Test",
  skin = "midnight",
  
  header     = dashboardHeader(),
  controlbar = dashboardControlbar(),
  
  ## Sidebar --------------------------------------------------------------------------------
  # Controls for sidebar layout
  
  sidebar = shinydashboardPlus::dashboardSidebar(
    
    # Sidebar menu
    sidebarMenu(
      
      # Menu tabs / item
      menuItem("Load Data", tabName = "tab_load", icon = icon("fas fa-upload") ),
      menuItem("Visualise", tabName = "tab_2", icon = icon("circle") )
      
    ) # End sidebar tabs
    
  ), # End sidebar menu
  
  
  ## Body --------------------------------------------------------------------------------
  # Controls for dashboard body
  # Each tab should have a module associated with it
  
  body = dashboardBody(
    
    
    tabItems(
    
            ### File upload module ----
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
                         selected = "head"),
          
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
                          
                        ),
                        
                        fluidRow(
                          column( width = 12,
                                  div(style = 'overflow-x: scroll', tableOutput("by_type") ) )
                          
                        )
                        
                        )

                   )
                        
                )
          )
        )
      ),
      
      tabItem( tabName = "tab_2", box( title = "A Box!", collapsible = TRUE, verbatimTextOutput("plot") ) )

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
    
    # if( input$disp == "head"){
    #   data_in <- head(data())
    # } else {
    #   data_in <- data()
    # }
    # 
    n_rows <- nrow( data() )
    n_sample_rows <- 30
    
    row_index <- sample( 1:n_rows, n_sample_rows, replace = F)
    
    data_in <- data()[row_index,]
    
    data_in %>% 
      knitr::kable("html") %>% 
      kable_styling( c("bordered", "hover"), full_width = F, position = "left", font_size = "11")
    
    
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
  
  

  output$by_type <- function(){
    
    # type <- unique( sapply( data(), class) )
    # 
    # type_output <- list()
    # for( i in seq_along(type) ){
    #   type_output[[i]] <-  tibble( type = sapply( iris, class) ) %>% 
    #     count(type) %>% 
    #     column_to_rownames("type")
    # }
    # names( type_output) <- type
    # 
    # 
    #   knitr::kable(type_output, "html", caption = "Data Types", col.names = c(" ")) %>% 
    #   kable_styling( full_width = T, position = "left", font_size = "12")
    
    for( i in 1:3) {
     knitr::kable(head(iris)) 
    }
    
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