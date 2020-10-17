library(tidyverse)

#################
# Load datafile #
#################

df <- read.csv(file = "data_files/ViewingActivity.csv",
           header = T) %>%
  separate(col = Title,
           into = c("Title", "Season", "episode"),
           sep = ":") %>%
filter(!Supplemental.Video.Type %in% 
         c("HOOK","PREVIEW","RECAP","TRAILER","PROMOTIONAL","TEASER_TRAILER")) 


# Parse the dates-and times columns in the df
df$Start.Time <- parse_datetime(df$Start.Time)
df$Duration <- parse_time(df$Duration)

df <- df %>% filter(Duration > 60) # Filter very short "accidental" views 
                                   #  Check by: df %>% ggplot(aes(x = Duration)) + geom_histogram(binwidth = 60)   

###################
# Total watchtime #
###################

df <- df %>% mutate("day" = weekdays(Start.Time, abbreviate = TRUE),
                       "month" = months(Start.Time),
                       "year" =  lubridate::year(Start.Time),
                    "week" = lubridate::week(Start.Time)
                       ) 
df$day = factor(df$day, levels = c("Mon","Tue","Wed","Thu","Fri","Sat","Sun"),
                    ordered = TRUE)
df$month = factor(df$month, levels = c("January","February","March","April",
                                         "May","June","July","August",
                                         "September","October","November","December"),
                   ordered = TRUE)

################################
# Plot wacht history over time #
################################

 df %>%
  ggplot(aes(x = lubridate::date(Start.Time), 
             y = Duration))+
  geom_bar(stat = "identity", aes(fill = month))+
  facet_grid(~year, scale = "free")
 

