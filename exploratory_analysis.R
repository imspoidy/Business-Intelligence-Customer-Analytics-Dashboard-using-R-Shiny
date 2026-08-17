library(dplyr)
library(ggplot2)
library(lubridate)

retail <- read.csv("data/processed/retail_features.csv")

retail$InvoiceDate <- ymd_hms(retail$InvoiceDate)
retail$MonthName <- factor(
  retail$MonthName,
  levels = c("Jan","Feb","Mar","Apr","May","Jun",
             "Jul","Aug","Sep","Oct","Nov","Dec")
)


total_revenue <- sum(retail$Revenue)

cat("Total Revenue:", round(total_revenue,2))


total_customers <- n_distinct(retail$Customer.ID)

cat("Customers:", total_customers)


total_invoices <- n_distinct(retail$Invoice)

cat("Invoices:", total_invoices)


invoice_summary <-
  retail %>%
  group_by(Invoice) %>%
  summarise(
    InvoiceValue = sum(Revenue)
  )

mean(invoice_summary$InvoiceValue)


monthly_sales <-
  retail %>%
  group_by(Year, MonthName) %>%
  summarise(
    Revenue = sum(Revenue),
    .groups = "drop"
  )


ggplot(monthly_sales,
       aes(
         x = MonthName,
         y = Revenue,
         group = Year,
         color = factor(Year)
       )) +
  
  geom_line(size=1.2)+
  
  geom_point(size=3)+
  
  labs(
    title="Monthly Revenue",
    x="Month",
    y="Revenue",
    color="Year"
  )+
  
  theme_minimal()


top_products <-
  
  retail %>%
  
  group_by(Description) %>%
  
  summarise(
    
    Revenue=sum(Revenue),
    
    .groups="drop"
    
  ) %>%
  
  arrange(desc(Revenue)) %>%
  
  slice(1:10)


ggplot(
  top_products,
  
  aes(
    
    reorder(Description,Revenue),
    
    Revenue
    
  )
  
)+
  
  geom_col()+
  
  coord_flip()+
  
  theme_minimal()+
  
  labs(
    
    title="Top 10 Products",
    
    x="",
    
    y="Revenue"
    
  )

country_sales <-
  
  retail %>%
  
  group_by(Country) %>%
  
  summarise(
    
    Revenue=sum(Revenue),
    
    .groups="drop"
    
  ) %>%
  
  arrange(desc(Revenue))


ggplot(
  
  country_sales[1:10,],
  
  aes(
    
    reorder(Country,Revenue),
    
    Revenue
    
  )
  
)+
  
  geom_col()+
  
  coord_flip()+
  
  theme_minimal()
