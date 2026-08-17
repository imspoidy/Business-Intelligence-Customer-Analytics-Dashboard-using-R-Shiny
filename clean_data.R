# ==========================================
# AI-Powered Customer Intelligence Platform
# Script: 03_clean_data.R
# Purpose: Clean raw retail data
# ==========================================

# Load libraries
library(readxl)
library(dplyr)

# Load raw data
retail_raw <- read_excel("data/raw/online_retail_II.xlsx")

# ------------------------------------------
# Remove duplicate rows
# ------------------------------------------
retail_clean <- retail_raw %>%
  distinct()

# ------------------------------------------
# Remove cancelled invoices
# (Invoices starting with "C")
# ------------------------------------------
retail_clean <- retail_clean %>%
  filter(!grepl("^C", Invoice))

# ------------------------------------------
# Keep only positive quantity
# ------------------------------------------
retail_clean <- retail_clean %>%
  filter(Quantity > 0)

# ------------------------------------------
# Keep only positive price
# ------------------------------------------
retail_clean <- retail_clean %>%
  filter(Price > 0)

# ------------------------------------------
# Remove missing Customer IDs
# ------------------------------------------
retail_clean <- retail_clean %>%
  filter(!is.na(`Customer ID`))

# ------------------------------------------
# Remove missing descriptions
# ------------------------------------------
retail_clean <- retail_clean %>%
  filter(!is.na(Description))

# ------------------------------------------
# Compare before and after cleaning
# ------------------------------------------
cat("========== CLEANING SUMMARY ==========\n\n")

cat("Rows Before :", nrow(retail_raw), "\n")
cat("Rows After  :", nrow(retail_clean), "\n")
cat("Rows Removed:", nrow(retail_raw) - nrow(retail_clean), "\n")

# Preview
head(retail_clean)

# ------------------------------------------
# Save Clean Dataset
# ------------------------------------------

write.csv(
  retail_clean,
  "data/processed/retail_clean.csv",
  row.names = FALSE
)

cat("\nClean dataset saved successfully!\n")
