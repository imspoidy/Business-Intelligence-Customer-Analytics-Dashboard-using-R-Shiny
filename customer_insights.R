library(dplyr)
library(ggplot2)
library(scales)

rfm <- read.csv("data/processed/customer_rfm.csv")
retail <- read.csv("data/processed/retail_features.csv")


customer_revenue <- retail %>%
  group_by(Customer.ID) %>%
  summarise(
    Revenue = sum(Revenue),
    .groups = "drop"
  )


customer_summary <- rfm %>%
  left_join(customer_revenue, by = "Customer.ID")

segment_report <- customer_summary %>%
  group_by(Segment) %>%
  summarise(
    
    Customers = n(),
    
    AvgRevenue = mean(Revenue),
    
    TotalRevenue = sum(Revenue),
    
    AvgFrequency = mean(Frequency),
    
    AvgRecency = mean(Recency),
    
    .groups = "drop"
    
  ) %>%
  
  arrange(desc(TotalRevenue))
segment_report

segment_report <- segment_report %>%
  
  mutate(
    
    RevenueShare =
      TotalRevenue /
      sum(TotalRevenue)
    
  )
segment_report

ggplot(segment_report,
       aes(
         x = reorder(Segment, TotalRevenue),
         y = TotalRevenue
       )) +
  
  geom_col(fill = "#2E86AB") +
  
  coord_flip() +
  
  scale_y_continuous(labels = dollar_format()) +
  
  labs(
    title = "Revenue by Customer Segment",
    x = "",
    y = "Revenue"
  ) +
  
  theme_minimal(base_size = 14)

ggplot(segment_report,
       aes(
         x = "",
         y = Customers,
         fill = Segment
       )) +
  
  geom_col(width = 1) +
  
  coord_polar(theta = "y") +
  
  theme_void() +
  
  labs(
    title = "Customer Distribution"
  )

segment_report <- segment_report %>%
  mutate(
    
    Recommendation = case_when(
      
      Segment == "Champions" ~
        "Reward with VIP offers",
      
      Segment == "Loyal Customers" ~
        "Increase retention through loyalty program",
      
      Segment == "Potential Loyalists" ~
        "Target with personalized promotions",
      
      Segment == "At Risk" ~
        "Launch win-back campaign",
      
      TRUE ~
        "Monitor customer behavior"
      
    )
    
  )
segment_report

write.csv(
  segment_report,
  "data/processed/customer_segment_report.csv",
  row.names = FALSE
)