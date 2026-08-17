# ==========================================
# AI-Powered Customer Intelligence Platform
# Script: 04_feature_engineering.R
# Purpose: Create business features
# ==========================================

# -----------------------------
# Load Libraries
# -----------------------------

library(dplyr)
library(lubridate)

# -----------------------------
# Load Clean Data
# -----------------------------

retail_clean <- read.csv(
  "data/processed/retail_clean.csv"
)

# Convert InvoiceDate back to datetime
retail_clean$InvoiceDate <- ymd_hms(retail_clean$InvoiceDate)

# -----------------------------
# Feature Engineering
# -----------------------------

retail_features <- retail_clean %>%
  
  mutate(
    
    # Revenue per transaction line
    Revenue = Quantity * Price,
    
    # Date Features
    Year = year(InvoiceDate),
    
    Month = month(InvoiceDate),
    
    MonthName = month(InvoiceDate, label = TRUE),
    
    Day = day(InvoiceDate),
    
    Weekday = wday(
      InvoiceDate,
      label = TRUE
    ),
    
    Hour = hour(InvoiceDate),
    
    Quarter = quarter(InvoiceDate)
  )

# -----------------------------
# Save Dataset
# -----------------------------

write.csv(
  retail_features,
  "data/processed/retail_features.csv",
  row.names = FALSE
)

cat("Feature engineering completed successfully.\n")