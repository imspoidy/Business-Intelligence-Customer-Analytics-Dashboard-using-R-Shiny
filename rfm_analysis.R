# ==========================================
# AI-Powered Customer Intelligence Platform
# Script: 06_rfm_analysis.R
# Purpose: Customer Segmentation using RFM
# ==========================================

library(dplyr)
library(lubridate)

# Load data
retail <- read.csv("data/processed/retail_features.csv")

retail$InvoiceDate <- ymd_hms(retail$InvoiceDate)

analysis_date <- max(retail$InvoiceDate) + days(1)

analysis_date

rfm <- retail %>%
  group_by(Customer.ID) %>%
  summarise(
    
    Recency =
      as.numeric(
        analysis_date - max(InvoiceDate)
      ),
    
    Frequency =
      n_distinct(Invoice),
    
    Monetary =
      sum(Revenue),
    
    .groups = "drop"
    
  )


head(rfm)

summary(rfm)

rfm <- rfm %>%
  
  mutate(
    
    R_Score =
      5 - ntile(Recency,5),
    
    F_Score =
      ntile(Frequency,5),
    
    M_Score =
      ntile(Monetary,5)
    
  )

rfm <- rfm %>%
  
  mutate(
    
    RFM_Score =
      paste0(
        R_Score,
        F_Score,
        M_Score
      )
    
  )


rfm <- rfm %>%
  
  mutate(
    
    Segment = case_when(
      
      R_Score >=4 &
        F_Score >=4 &
        M_Score >=4
      ~ "Champions",
      
      R_Score >=3 &
        F_Score >=3
      ~ "Loyal Customers",
      
      R_Score >=4 &
        F_Score <=2
      ~ "Potential Loyalists",
      
      R_Score <=2 &
        F_Score >=3
      ~ "At Risk",
      
      TRUE
      ~ "Others"
      
    )
    
  )

write.csv(
  rfm,
  "data/processed/customer_rfm.csv",
  row.names = FALSE
)


rfm %>%
  count(Segment)

segment_summary <- rfm %>%
  count(Segment)
segment_summary


ggplot(segment_summary,
       aes(
         x = reorder(Segment, n),
         y = n
       )) +
  
  geom_col() +
  
  coord_flip() +
  
  labs(
    title = "Customer Segments",
    x = "",
    y = "Number of Customers"
  ) +
  
  theme_minimal()

