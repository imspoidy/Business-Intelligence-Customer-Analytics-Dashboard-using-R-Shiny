server <- function(input, output, session) {
  
  #=========================================================
  # KPI Cards
  #=========================================================
  
  output$rev <- renderValueBox({
    
    valueBox(
      dollar(sum(retail$Revenue)),
      "Total Revenue",
      icon = icon("dollar-sign"),
      color = "green"
    )
    
  })
  
  output$cust <- renderValueBox({
    
    valueBox(
      comma(n_distinct(retail$Customer.ID)),
      "Customers",
      icon = icon("users"),
      color = "blue"
    )
    
  })
  
  output$orders <- renderValueBox({
    
    valueBox(
      comma(n_distinct(retail$Invoice)),
      "Orders",
      icon = icon("shopping-cart"),
      color = "orange"
    )
    
  })
  
  output$avg <- renderValueBox({
    
    avg_order <- sum(retail$Revenue) /
      n_distinct(retail$Invoice)
    
    valueBox(
      dollar(round(avg_order,2)),
      "Average Order",
      icon = icon("chart-line"),
      color = "purple"
    )
    
  })
  
  #=========================================================
  # Monthly Revenue
  #=========================================================
  
  output$sales <- renderPlotly({
    
    monthly <- retail %>%
      mutate(
        Month = floor_date(
          InvoiceDate,
          "month"
        )
      ) %>%
      group_by(Month) %>%
      summarise(
        Revenue = sum(Revenue),
        .groups = "drop"
      )
    
    p <- ggplot(
      monthly,
      aes(Month, Revenue)
    ) +
      geom_line(
        color = "#2E86DE",
        linewidth = 1.2
      ) +
      geom_point(
        color = "#2E86DE",
        size = 2
      ) +
      theme_minimal()
    
    ggplotly(p)
    
  })
  
  #=========================================================
  # Revenue by Country
  #=========================================================
  
  output$countrySales <- renderPlotly({
    
    country <- retail %>%
      group_by(Country) %>%
      summarise(
        Revenue = sum(Revenue),
        .groups = "drop"
      ) %>%
      arrange(desc(Revenue)) %>%
      slice_head(n = 10)
    
    p <- ggplot(
      
      country,
      
      aes(
        
        reorder(Country, Revenue),
        
        Revenue
        
      )
      
    ) +
      
      geom_col(
        
        fill = "#27AE60"
        
      ) +
      
      coord_flip() +
      
      theme_minimal()
    
    ggplotly(p)
    
  })
  
  #=========================================================
  # Top Products
  #=========================================================
  
  output$topProducts <- renderPlotly({
    
    top <- product_summary %>%
      
      slice_head(n = 10)
    
    p <- ggplot(
      
      top,
      
      aes(
        
        reorder(Description, Revenue),
        
        Revenue
        
      )
      
    ) +
      
      geom_col(
        
        fill = "#3498DB"
        
      ) +
      
      coord_flip() +
      
      theme_minimal()
    
    ggplotly(p)
    
  })
  
  #=========================================================
  # Customer Segments
  #=========================================================
  
  output$segmentPlot <- renderPlotly({
    
    p <- ggplot(
      
      segment_report,
      
      aes(
        
        Segment,
        
        Customers
        
      )
      
    ) +
      
      geom_col(
        
        fill = "#6C5CE7"
        
      ) +
      
      theme_minimal()
    
    ggplotly(p)
    
  })
  
  #=========================================================
  # CLV Histogram
  #=========================================================
  
  output$clvPlot <- renderPlotly({
    
    p <- ggplot(
      
      clv,
      
      aes(CLV)
      
    ) +
      
      geom_histogram(
        
        bins = 30,
        
        fill = "#00B894"
        
      ) +
      
      theme_minimal()
    
    ggplotly(p)
    
  })

  #=========================================================
  # Top Customers Table
  #=========================================================
  
  output$topCustomers <- renderDT({
    
    top_customers <- retail %>%
      group_by(Customer.ID) %>%
      summarise(
        Revenue = sum(Revenue),
        Orders = n_distinct(Invoice),
        .groups = "drop"
      ) %>%
      arrange(desc(Revenue)) %>%
      slice_head(n = 10)
    
    datatable(
      top_customers,
      options = list(
        pageLength = 10,
        searching = FALSE,
        info = FALSE
      ),
      rownames = FALSE
    )
    
  })
  
  #=========================================================
  # Products Page - Top Products
  #=========================================================
  
  output$topProducts2 <- renderPlotly({
    
    top_products <- product_summary %>%
      slice_head(n = 10)
    
    p <- ggplot(
      top_products,
      aes(
        reorder(Description, Revenue),
        Revenue
      )
    ) +
      geom_col(fill = "#3498DB") +
      coord_flip() +
      labs(
        x = "Product",
        y = "Revenue"
      ) +
      theme_minimal()
    
    ggplotly(p)
    
  })
  
  #=========================================================
  # Pareto Analysis
  #=========================================================
  
  output$paretoChart <- renderPlotly({
    
    pareto <- product_summary %>%
      arrange(desc(Revenue)) %>%
      mutate(
        CumRevenue = cumsum(Revenue),
        CumPercent = CumRevenue / sum(Revenue) * 100
      ) %>%
      slice_head(n = 15)
    
    p <- ggplot(
      pareto,
      aes(x = reorder(Description, Revenue))
    ) +
      geom_col(
        aes(y = Revenue),
        fill = "#2E86DE"
      ) +
      geom_line(
        aes(
          y = CumPercent / 100 * max(Revenue),
          group = 1
        ),
        color = "red",
        linewidth = 1
      ) +
      geom_point(
        aes(
          y = CumPercent / 100 * max(Revenue)
        ),
        color = "red",
        size = 2
      ) +
      coord_flip() +
      labs(
        x = "Product",
        y = "Revenue"
      ) +
      theme_minimal()
    
    ggplotly(p)
    
  })
  
}