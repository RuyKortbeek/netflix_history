library(tidyverse)

#################
# Load datafile #
#################

df <- read.csv(file = "data_files/ViewingActivity.csv",
           header = T, sep = ",")

# Parse the dates-and times columns in the df
df$Start.Time <- parse_datetime(df$Start.Time)
df$Duration <- parse_time(df$Duration)

