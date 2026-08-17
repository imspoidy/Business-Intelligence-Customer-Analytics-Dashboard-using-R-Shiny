#=========================================================
# UI
#=========================================================

ui <- dashboardPage(
  
  dashboardHeader(
    title = "Online Retail Dashboard"
  ),
  
  dashboardSidebar(
    
    sidebarMenu(
      
      menuItem(
        "Dashboard",
        tabName = "dashboard",
        icon = icon("dashboard")
      ),
      
      menuItem(
        "Customers",
        tabName = "customers",
        icon = icon("users")
      ),
      
      menuItem(
        "Products",
        tabName = "products",
        icon = icon("shopping-cart")
      ),
      
      menuItem(
        "About",
        tabName = "about",
        icon = icon("info-circle")
      )
      
    )
    
  ),
  
  dashboardBody(
    
    tabItems(
      
      #=========================================================
      # Dashboard
      #=========================================================
      
      tabItem(
        
        tabName = "dashboard",
        
        fluidRow(
          
          valueBoxOutput("rev", width = 3),
          valueBoxOutput("cust", width = 3),
          valueBoxOutput("orders", width = 3),
          valueBoxOutput("avg", width = 3)
          
        ),
        
        fluidRow(
          
          box(
            title = "Monthly Revenue",
            width = 8,
            status = "primary",
            solidHeader = TRUE,
            plotlyOutput("sales", height = "350px")
          ),
          
          box(
            title = "Revenue by Country",
            width = 4,
            status = "success",
            solidHeader = TRUE,
            plotlyOutput("countrySales", height = "350px")
          )
          
        ),
        
        fluidRow(
          
          box(
            title = "Top Products",
            width = 12,
            status = "warning",
            solidHeader = TRUE,
            plotlyOutput("topProducts", height = "400px")
          )
          
        )
        
      ),
      
      #=========================================================
      # Customers
      #=========================================================
      
      tabItem(
        
        tabName = "customers",
        
        fluidRow(
          
          box(
            title = "Customer Segments",
            width = 6,
            status = "primary",
            solidHeader = TRUE,
            plotlyOutput("segmentPlot", height = "350px")
          ),
          
          box(
            title = "Customer Lifetime Value",
            width = 6,
            status = "primary",
            solidHeader = TRUE,
            plotlyOutput("clvPlot", height = "350px")
          )
          
        ),
        
        fluidRow(
          
          box(
            title = "Top Customers",
            width = 12,
            status = "primary",
            solidHeader = TRUE,
            DTOutput("topCustomers")
          )
          
        )
        
      ),
      
      #=========================================================
      # Products
      #=========================================================
      
      tabItem(
        
        tabName = "products",
        
        fluidRow(
          
          box(
            title = "Top Products",
            width = 6,
            status = "primary",
            solidHeader = TRUE,
            plotlyOutput("topProducts2", height = "400px")
          ),
          
          box(
            title = "Pareto Analysis",
            width = 6,
            status = "warning",
            solidHeader = TRUE,
            plotlyOutput("paretoChart", height = "400px")
          )
          
        )
        
      ),
      
      #=========================================================
      # About
      #=========================================================
      
      tabItem(
        
        tabName = "about",
        
        fluidRow(
          
          box(
            
            width = 12,
            
            title = "About This Project",
            
            status = "primary",
            
            solidHeader = TRUE,
            
            h3("Online Retail Dashboard"),
            
            p("Course: Business Intelligence"),
            
            p("Dataset: Online Retail"),
            
            p("This dashboard provides a simple analysis of sales, customers and products using R Shiny.")
            
          )
          
        )
        
      )
      
    )
    
  )
  
)