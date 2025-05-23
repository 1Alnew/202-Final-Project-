library(readr)
library(tidyverse)
data <- read_csv("https://raw.githubusercontent.com/1Alnew/202-Final-Project-/refs/heads/main/Crime_Incidents_in_2024.csv")
#link to web page: https://opendata.dc.gov/datasets/DCGIS::crime-incidents-in-2024/about
view(data)
dim(data)
summary(data)
unique(data$OFFENSE)
data <- data %>%  select(-OCTO_RECORD_ID)
data$DISTRICT <- as.character(data$DISTRICT)
data$WARD <- as.character(data$WARD)

