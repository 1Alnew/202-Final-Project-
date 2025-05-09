library(readr)
library(tidyverse)
data <- read_csv("https://raw.githubusercontent.com/1Alnew/202-Final-Project-/refs/heads/main/Crime_Incidents_in_2024.csv")
data <- data %>%  select(-OCTO_RECORD_ID)
data$DISTRICT <- as.character(data$DISTRICT)
data$WARD <- as.character(data$WARD) 
view(data)
econ <- read_csv("https://raw.githubusercontent.com/1Alnew/202-Final-Project-/refs/heads/main/ACS_5-Year_Economic_Characteristics_DC_Ward.csv")
view(econ)

data %>% ggplot(
  aes(x=OFFENSE, fill=OFFENSE)
)+geom_bar()+
  facet_wrap(~WARD)+
  theme(axis.text.x=element_blank()) 

ward_poverty <- econ[c('NAME', 'DP03_0128PE')]
ward_poverty$NAME <- parse_number(ward_poverty$NAME)
colnames(ward_poverty)[colnames(ward_poverty) == 'NAME'] <- 'WARD'
colnames(ward_poverty)[colnames(ward_poverty) == 'DP03_0128PE'] <- '% impoverished'
ward_poverty$WARD <- as.character(ward_poverty$WARD)
ward_poverty

wards <- data %>% drop_na(WARD) %>% count(WARD)
wards <- full_join(wards, ward_poverty, by = "WARD")
wards

ggplot(
  wards,
  aes(x=WARD, y=n, fill=`% impoverished`)
)+geom_col()+
  scale_fill_gradient(low="#fc96ec", high = "#7c0069")+
  labs(y = "No. of Crimes", x = "Ward")
  
# Filtering to make finding block which contains White House easier
penn <- data %>% filter(grepl("PENNSYLVANIA AVENUE", data$BLOCK, fixed = TRUE))
#unique(penn$BLOCK) Looking at values to find which contains the White House
penn <- penn %>% filter(BLOCK == "1500 - 1649 BLOCK OF PENNSYLVANIA AVENUE SE")
penn %>%  ggplot(
  aes(x=OFFENSE, fill=OFFENSE)
)+geom_bar()+
  theme(axis.text.x=element_blank())+
  labs(title="Crimes on the White House Block")

capitol <- data %>% filter(BID == "CAPITOL HILL")
capitol %>%  ggplot(
  aes(x=OFFENSE, fill=OFFENSE)
)+geom_bar()+
  theme(axis.text.x=element_blank())+
  labs(title="Crimes on Capitol Hill")

