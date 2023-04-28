
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
    
  ),
  
  footer  = dashboardFooter()
  
)
  
  