library(tidyverse)

#################
# Load datafile #
#################

df <- read.csv(file = "data_files/ViewingActivity.csv",
           header = T)

# Parse the dates-and times columns in the df
df$Start.Time <- parse_datetime(df$Start.Time)
df$Duration <- parse_time(df$Duration)

###################
# Total watchtime #
###################

df2 = df %>% mutate("day" = weekdays(Start.Time, abbreviate = TRUE),
                       "month" = months(Start.Time),
                       "year" =  lubridate::year(Start.Time)
                       ) 
df2$day = factor(df2$day, levels = c("Mon","Tue","Wed","Thu","Fri","Sat","Sun"),
                    ordered = TRUE)
df2$month = factor(df2$month, levels = c("January","February","March","April",
                                         "May","June","July","August",
                                         "September","October","November","December"),
                   ordered = TRUE)

 df2 %>%
  dplyr::group_by(day, month, year) %>%
  dplyr::summarise("total" = sum(Duration)/3600) %>% 
  ggplot(aes(x = day, y = total))+
  geom_bar(stat = "identity")+
  facet_grid(year~month, scale = "free")
 
 df2 %>%
   ggplot(aes(x = lubridate::date(Start.Time),
          y = Duration)) + 
   geom_line()
