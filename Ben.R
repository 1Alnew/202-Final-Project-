library(readr)
library(tidyverse)
library(ggplot2)
library(dplyr)

data <- read_csv("https://raw.githubusercontent.com/1Alnew/202-Final-Project-/refs/heads/main/Crime_Incidents_in_2024.csv")
data <- data %>%  select(-OCTO_RECORD_ID)
data$DISTRICT <- as.character(data$DISTRICT)
data$WARD <- as.character(data$WARD)

view(data)
summary(data)


data <- data %>%
  filter(!is.na(SHIFT), !is.na(OFFENSE), !is.na(METHOD))

data <- data %>%
  mutate(
    SHIFT = as.factor(SHIFT),
    OFFENSE = as.factor(OFFENSE),
    METHOD = as.factor(METHOD)
  )

# 1a
ggplot(data, aes(x = SHIFT)) +
  geom_bar(fill = "steelblue") +
  labs(
    title = "Crime Frequency by Shift",
    x = "Shift",
    y = "Number of Crimes"
  ) +
  theme_minimal()

# 1b
top_offenses <- data %>%
  count(OFFENSE, sort = TRUE) %>%
  top_n(5, n) %>%
  pull(OFFENSE)

data %>%
  filter(OFFENSE %in% top_offenses) %>%
  ggplot(aes(x = SHIFT, fill = OFFENSE)) +
  geom_bar(position = "dodge") +
  theme(axis.text.x=element_blank())+
  scale_fill_brewer(palette = "Set3")+
  labs(
    title = "Top 5 Crime Types by Shift",
    x = "Shift",
    y = "Number of Crimes",
    fill = "Offense Type"
  ) +
  theme_minimal()

# 2b
data %>%
  filter(OFFENSE %in% top_offenses) %>%
  ggplot(aes(x = METHOD, fill = OFFENSE)) +
  geom_bar(position = "dodge") +
  theme(axis.text.x=element_blank())+
  scale_fill_brewer(palette = "Set3")+
  facet_wrap(~ OFFENSE, scales = "free_x") +
  labs(
    title = "Common Methods Used by Top 5 Crime Types",
    x = "Method",
    y = "Number of Crimes",
    fill = "Offense"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 2b (LOG)
data %>%
  filter(OFFENSE %in% top_offenses) %>%
  ggplot(aes(x = METHOD, fill = OFFENSE)) +
  geom_bar(position = "dodge") +
  theme(axis.text.x=element_blank())+
  scale_fill_brewer(palette = "Set3")+
  facet_wrap(~ OFFENSE, scales = "free_x") +
  scale_y_log10() +
  labs(
    title = "Common Methods Used by Top 5 Crime Types (Log Scale)",
    x = "Method",
    y = "Log10(Number of Crimes)",
    fill = "Offense"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))