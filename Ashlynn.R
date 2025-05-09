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
    title = "Top 10 Locations by Crime Count per Day",
    x = "Location",
    y = "Crime Count"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


top_10_per_shift$BLOCK <- sub("___.*$", "", top_10_per_shift$BLOCK)


excluded_locations <- c(
  "812 - 899 BLOCK OF BLADENSBURG ROAD NE", 
  "600 - 669 BLOCK OF PENNSYLVANIA AVENUE SE",
  "1000 - 1099 BLOCK OF 16TH STREET NW",
  "1516 - 1699 BLOCK OF BENNING ROAD NE",
  "100 - 199 BLOCK OF CARROLL STREET NW",
  "3200 - 3275 BLOCK OF M STREET NW",
  "1600 - 1699 BLOCK OF P STREET NW",
  "2600 - 2649 BLOCK OF CONNECTICUT AVENUE NW",
  "6500 - 6599 BLOCK OF GEORGIA AVENUE NW",
  "1100 - 1199 BLOCK OF U STREET NW",
  "1300 - 1399 BLOCK OF OKIE STREET NE",
  "1800 - 2299 BLOCK OF NEW YORK AVENUE NE",
  "4000 - 4121 BLOCK OF MINNESOTA AVENUE NE",
  "2100 - 2199 BLOCK OF 24TH PLACE NE",
  "1 - 7 BLOCK OF DUPONT CIRCLE NW"
)

filtered_crime <- top_10_per_shift %>%
  filter(!BLOCK %in% excluded_locations)

ggplot(filtered_crime, aes(x = BLOCK, y = count, fill = SHIFT)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~SHIFT, scales = "free") +
  scale_x_discrete(labels = function(x) gsub("___.*", "", x)) +
  labs(
    title = "Top 10 Locations by Crime Count per Day",
    x = "Location",
    y = "Crime Count"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


neighborhood_crimes <- data %>%
  count(OFFENSE,NEIGHBORHOOD_CLUSTER, name = "count")

neighborhood_crimes <- neighborhood_crimes %>%
  filter(!is.na(OFFENSE), !is.na(NEIGHBORHOOD_CLUSTER))


ggplot(neighborhood_crimes, aes(x = NEIGHBORHOOD_CLUSTER, y = count, fill = OFFENSE)) +
  geom_col() +
  labs(
    title = "Crime Count by Neighborhood Cluster and Offense Type",
    x = "Neighborhood Cluster",
    y = "Total Crime Count",
    fill = "Offense"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "bottom"
  )


