library(readr)
data <- read_csv("Health_conditions_among_children_under_age_18__by_selected_characteristics__United_States.csv")
print(unique(data$INDICATOR))
data <- subset(data, select = -INDICATOR)
print(unique(data$FLAG))

