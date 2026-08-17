# ==========================================
# AI-Powered Customer Intelligence Platform
# Script: 02_data_quality.R
# Purpose: Data Quality Assessment
# ==========================================

# Load Libraries
library(readxl)
library(dplyr)

# ------------------------------------------
# Load Data
# ------------------------------------------
retail_raw <- read_excel("data/raw/online_retail_II.xlsx")

# ------------------------------------------
# Dataset Overview
# ------------------------------------------
cat("========================================\n")
cat("        DATA QUALITY REPORT\n")
cat("========================================\n\n")

cat("Rows    :", nrow(retail_raw), "\n")
cat("Columns :", ncol(retail_raw), "\n\n")

# ------------------------------------------
# Missing Values
# ------------------------------------------
cat("========== Missing Values ==========\n")
print(colSums(is.na(retail_raw)))

# ------------------------------------------
# Duplicate Rows
# ------------------------------------------
cat("\n========== Duplicate Rows ==========\n")
cat(sum(duplicated(retail_raw)), "\n")

# ------------------------------------------
# Negative Quantity
# ------------------------------------------
cat("\n========== Negative Quantity ==========\n")
cat(sum(retail_raw$Quantity < 0, na.rm = TRUE), "\n")

# ------------------------------------------
# Zero or Negative Price
# ------------------------------------------
cat("\n========== Zero / Negative Price ==========\n")
cat(sum(retail_raw$Price <= 0, na.rm = TRUE), "\n")

# ------------------------------------------
# Cancelled Invoices
# ------------------------------------------
cat("\n========== Cancelled Invoices ==========\n")
cat(sum(grepl("^C", retail_raw$Invoice)), "\n")

# ------------------------------------------
# Unique Counts
# ------------------------------------------
cat("\n========== Unique Counts ==========\n")

cat("Customers :", n_distinct(retail_raw$`Customer ID`), "\n")
cat("Invoices  :", n_distinct(retail_raw$Invoice), "\n")
cat("Products  :", n_distinct(retail_raw$StockCode), "\n")
cat("Countries :", n_distinct(retail_raw$Country), "\n")