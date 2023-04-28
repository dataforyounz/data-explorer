
module_upload_ui <- function(id){
  
  sidebarLayout(
    
    sidebarPanel = sidebarPanel( width = 3,
      
      selectInput( inputId = NS(id, "datasets"), label = "Datasets", choices = data( package = "datasets")$results[,"Item"], selected = "iris", selectize = F),
      actionButton( inputId = NS(id, "load_data"), label = "Load" ),
      
      tags$hr(),
      
      fileInput( NS(id, "file_in"), 
                label = "Choose CSV File",
                multiple = FALSE,
                accept = c( "text/csv",
                            "text/comma-separated-values,text/plain",
                            ".csv" )
                ),
      
      # Horizontal line ----
      
      tags$hr(),
      
    ), # End sidebar panel
  
      mainPanel = mainPanel( width = 9,
                             
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
      ) # End Main panel 
               
  ) # End sidebar layout
}



