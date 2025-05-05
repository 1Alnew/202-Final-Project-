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

library(ggplot2)
library(dplyr)
data %>% arrange(desc(SHIFT), METHOD, desc(BLOCK)) %>% head()
data %>% arrange(desc(SHIFT), METHOD, desc(BLOCK)) %>%
  select(METHOD, BLOCK, SHIFT, OFFENSE) %>% head()
data$SHIFT <- factor(data$SHIFT)
summary(data$SHIFT)

day_crime <- data %>%
  group_by(SHIFT,BLOCK) %>%
  summarise(count =n(),.groups = "drop")

  
top_10_per_shift <- day_crime %>%
    group_by(SHIFT) %>%
    slice_max(order_by = count, n = 10, with_ties = FALSE) %>%
    arrange(SHIFT, desc(count))


top_10_per_shift <- top_10_per_shift %>%
  mutate(BLOCK = reorder(paste(BLOCK, SHIFT, sep = "___"), count))

ggplot(top_10_per_shift, aes(x = BLOCK, y = count, fill = SHIFT)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~SHIFT, scales = "free") +
  scale_x_discrete(labels = function(x) gsub("___.*", "", x)) +
  labs(
    title = "Top 10 Locations by Crime Count per Shift",
    x = "Location",
    y = "Crime Count"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
