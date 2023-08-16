

library(tidyverse)
library(dplyr)
library(plotly)
library(ggthemes)
library(ggeasy)
library(ggpubr)
library(RCurl)
library(rjson)
library(jsonlite)
library(prophet)
library(quantmod)
library(forecast)
library(tseries)
library(timeSeries)
library(forecast)
library(ggplot2)
library(cronR)

options("getSymbols.warning4.0"=FALSE)
options("getSymbols.yahoo.warning"=FALSE)

stocksym = "O"

O_data <- getSymbols(Symbols = stocksym, src = "yahoo", from = "1994-10-21", to = Sys.Date(), auto.assign = FALSE)

df_o <- data.frame(ds = index(O_data),
                 y = as.numeric(O_data[,'O.Close']))

prophetpred <- prophet(df_o)
future <- make_future_dataframe(prophetpred, periods = 31)
forecastprophet <- predict(prophetpred, future)

df_pred <- forecastprophet %>% select(ds, yhat_lower, yhat_upper, yhat)

df_o_full<-left_join(df_o, df_pred, by = "ds")

df_o_full$Under_Expectations<-ifelse(df_o_full$y<df_o_full$yhat,1,0)
df_o_full$Over_Expectations<-ifelse(df_o_full$y>df_o_full$yhat,1,0)


# Example input list
input_list_under <- df_o_full$Under_Expectations

# Initialize variables
current_streak_under <- 0
streaks_under <- c()
in_streak_under <- FALSE

# Iterate through the list
for (i in input_list_under) {
  if (i == 1) {
    if (!in_streak_under) {
      in_streak_under <- TRUE
      current_streak_under <- 1
    } else {
      current_streak_under <- current_streak_under + 1
    }
  } else {
    if (in_streak_under) {
      in_streak_under <- FALSE
      streaks_under <- c(streaks_under, current_streak_under)
      current_streak_under <- 0
    }
  }
}
# If the input list ends with a streak of 1s
if (in_streak_under) {
  streaks_under <- c(streaks_under, current_streak_under)
}
# Create a data frame
streak_df_under <- data.frame(Streak_Length = streaks_under)
# Print the resulting data frame
days_under_expectations <- mean(streak_df_under$Streak_Length)


#### Email language ####

if (in_streak_under == TRUE) {
  lang_under = paste0("The current price for O is UNDER expectations. The current price for O has been UNDER expectations for ", current_streak_under, "days. On average, O has stayed under expectations for", days_under_expectations, ". This is not financial advice", sep = "")
  print(lang_under)
} else {
  print("try again")
}


















