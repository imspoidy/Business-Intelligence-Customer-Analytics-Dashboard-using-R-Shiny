retail <- read.csv("data/processed/retail_features.csv")

retail$InvoiceDate <- ymd_hms(retail$InvoiceDate)

monthly_sales <- retail %>%
  mutate(
    Month = floor_date(InvoiceDate, "month")
  ) %>%
  group_by(Month) %>%
  summarise(
    Revenue = sum(Revenue),
    .groups = "drop"
  )
monthly_sales

sales_ts <- ts(
  monthly_sales$Revenue,
  frequency = 12
)

model <- auto.arima(sales_ts)
summary(model)

forecast_sales <- forecast(
  model,
  h = 6
)

autoplot(forecast_sales) +
  labs(
    title = "Sales Forecast (Next 6 Months)",
    x = "Time",
    y = "Revenue"
  )
forecast_sales