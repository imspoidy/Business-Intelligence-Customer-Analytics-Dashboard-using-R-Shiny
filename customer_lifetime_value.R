library(dplyr)

rfm <- read.csv("data/processed/customer_rfm.csv")

rfm <- rfm %>%
  
  mutate(
    
    CLV =
      Monetary *
      Frequency
    
  )

rfm <- rfm %>%
  
  mutate(
    
    CLV_Level = case_when(
      
      CLV >= quantile(CLV,0.90)
      ~ "Very High",
      
      CLV >= quantile(CLV,0.70)
      ~ "High",
      
      CLV >= quantile(CLV,0.40)
      ~ "Medium",
      
      TRUE
      ~ "Low"
      
    )
    
  )
table(rfm$CLV_Level)

library(ggplot2)

ggplot(rfm,
       aes(CLV_Level))+
  
  geom_bar(fill="#4CAF50")+
  
  theme_minimal(base_size=14)+
  
  labs(
    
    title="Customer Lifetime Value Distribution",
    
    x="CLV Level",
    
    y="Customers"
    
  )

write.csv(
  
  rfm,
  
  "data/processed/customer_clv.csv",
  
  row.names=FALSE
  
)