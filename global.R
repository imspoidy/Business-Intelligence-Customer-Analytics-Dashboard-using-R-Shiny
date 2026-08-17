#=========================================================
# Libraries
#=========================================================

library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(plotly)
library(DT)
library(lubridate)
library(scales)
library(readxl)

#=========================================================
# Load Data
#=========================================================

data <- read_excel("C:/Users/HUAWEI/Desktop/R project's data/data/raw/online_retail_II.xlsx")
#=========================================================
# Data Cleaning
#=========================================================

retail <- retail %>%
  filter(
    Quantity > 0,
    Price > 0
  )

# إذا كان Revenue غير موجود احسبه، وإلا احتفظ به
if (!"Revenue" %in% names(retail)) {
  retail <- retail %>%
    mutate(
      Revenue = Quantity * Price
    )
}

#=========================================================
# Customer Segmentation
#=========================================================

segment_report <- retail %>%
  group_by(Customer.ID) %>%
  summarise(
    Revenue = sum(Revenue),
    Orders = n_distinct(Invoice),
    .groups = "drop"
  ) %>%
  mutate(
    Segment = case_when(
      Revenue >= quantile(Revenue, 0.75) ~ "High Value",
      Revenue >= quantile(Revenue, 0.50) ~ "Medium Value",
      TRUE ~ "Low Value"
    )
  ) %>%
  group_by(Segment) %>%
  summarise(
    Customers = n(),
    .groups = "drop"
  )

#=========================================================
# Customer Lifetime Value (Simple)
#=========================================================

clv <- retail %>%
  group_by(Customer.ID) %>%
  summarise(
    CLV = sum(Revenue),
    .groups = "drop"
  )

#=========================================================
# Product Summary
#=========================================================

product_summary <- retail %>%
  group_by(Description) %>%
  summarise(
    Revenue = sum(Revenue),
    Quantity = sum(Quantity),
    Orders = n_distinct(Invoice),
    .groups = "drop"
  ) %>%
  arrange(desc(Revenue))