install.packages("gmailr")
install.packages("cronR")
library(gmailr)
library(cronR)



source("C:/Users/PeterDola/OneDrive - Avantus/stockanalysis/ModelCreation.R")

setwd("C:/Users/PeterDola/OneDrive - Avantus/Desktop")
gm_auth_configure(path = "stockanalysisretry.json")

# Function to send a test email
send_test_email <- function() {
  email <- gm_mime(
    To = "meganlkoch@gmail.com",  # Replace with the recipient's email address
    From = "petersanalysis@gmail.com",  # Replace with your Gmail email address
    Subject = "Test Email",
    body = "This is a test email sent from R using the Gmail API."
  )
  gm_send_message(email)
}

# Send the test email
send_test_email()

gm_deauth()





