library(readr)
library(tidyverse)
library(ggplot2)
library(dplyr)

data <- read_csv("https://raw.githubusercontent.com/1Alnew/202-Final-Project-/refs/heads/main/Crime_Incidents_in_2024.csv")
data <- data %>%  select(-OCTO_RECORD_ID)
data$DISTRICT <- as.character(data$DISTRICT)
data$WARD <- as.character(data$WARD)