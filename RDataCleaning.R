#Import necessary libraries
library(tidyverse)
library(readxl)

#import file, drops duplicate rows, drops columns. Columns will be specific to data set. 
df <- read_xlsx("/Users/gagewagner/Documents/Datasets/Customer Call List.xlsx")
df <- df[!duplicated(df),]
df <- select(df,-"Not_Useful_Column")

#Cleans data of any leading or trailing non alphanumeric characters
df$Last_Name <- gsub("[^a-zA-Z]","",df$Last_Name)
df$Last_Name <- trimws(df$Last_Name)

#Cleans and formats Phone Number
df$Phone_Number <- gsub("[^a-zA-Z0-9]","",df$Phone_Number)
df$Phone_Number <- gsub("^(\\d{3})(\\d{3})(\\d{4})$", "\\1-\\2-\\3", df$Phone_Number)
df$Phone_Number[df$Phone_Number == "Na"] <- ""
df$Phone_Number[is.na(df$Phone_Number)] <- ""

#Splits address into 3 columns
df <- df %>% separate_wider_delim(Address, delim=",", names=c("Street_Address","State","Zip_Code"), too_few = "align_start")
df$State <- trimws(df$State)
df$Zip_Code <- trimws(df$Zip_Code)

#Replaces Yes and No with Y and N
df$`Paying Customer` <- gsub("Yes","Y",df$`Paying Customer`)
df$`Paying Customer` <- gsub("No","N",df$`Paying Customer`)
df$Do_Not_Contact <- gsub("Yes","Y",df$Do_Not_Contact)
df$Do_Not_Contact <- gsub("No","N",df$Do_Not_Contact)

#Removes N/As in the dataset. 
df[is.na(df)] <- ""
df[] <- lapply(df, function(x) gsub("N/a", "", x))

#Drop Do Not Contact
df <- df[df$Do_Not_Contact == "N",]

#Drop Blank Phone Number
df <- df[!df$Phone_Number == "",]



