## code to prepare `login_data` dataset goes here
login_data <- read.csv("data-raw/login_data.csv")
usethis::use_data(login_data, overwrite = TRUE)
