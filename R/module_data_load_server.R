
module_upload_server <- function(id){

  moduleServer(id, function(input, output, session) {

    data <- eventReactive(input$load_data, {
      
      get( input$datasets )
      
    })
    
    output$contents <- renderTable({
      
      data_in <- data()
      
      n_rows <- nrow( data_in )
      n_sample_rows <- 30
      
      row_index <- sample( 1:n_rows, n_sample_rows, replace = F )
      
      data_in[row_index,]
      
    })
      
    #   function(){
    #   
    #   
    # 
    #   
    #   data_in %>% 
    #     split( row_index ) %>%
    #     knitr::kable("html") %>% 
    #     kable_styling( c("bordered", "hover"), full_width = T, position = "left", font_size = "11")
    #   
    # }

    
  })
}