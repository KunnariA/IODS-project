# Week 3 of Introduction to Open Data Science
# Anton Kunnari 09/11/2020
# Data is from https://archive.ics.uci.edu/ml/datasets/Student+Performance

library(tidyverse)

dat1 <- read.csv("/home/master/Documents/Koodaus/R/IODS-project/data/student-mat.csv", sep=";")
dat2 <- read.csv("/home/master/Documents/Koodaus/R/IODS-project/data/student-por.csv", sep=";")

dim(dat1) # 395 observations, 33 variables
dim(dat2) # 649 observations, 33 variables

names(dat1)
names(dat2) # Identical variable names in the two datasets

dat_joint <- rbind(
  dat1 %>%
    dplyr::select(school, sex, age, address, famsize, 
                  Pstatus, Medu, Fedu, Mjob, Fjob, reason),
  dat2 %>%
    dplyr::select(school, sex, age, address, famsize, 
                  Pstatus, Medu, Fedu, Mjob, Fjob, reason)
)


# Merge the two datasets
join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")

dat3= merge(dat1, dat2, by= join_by)

dim(dat3) # 405 observations, 54 variables

notjoined_columns <- colnames(dat1)[!colnames(dat1) %in% join_by]

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  
  variable <- grep(column_name, names(dat3))
  
  # Take the value from both datasets
  columns <- cbind(dat3[,variable[1]], dat3[,variable[2]])
  
  # if that first column  vector is numeric...
  if(is.numeric(col1)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    dat3[column_name] <- round(rowMeans(columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    dat3[column_name] <- dat3[,variable[1]]
  }
}

# Create new variable alc_yyse
dat3 <- dat3 %>%
  mutate(alc_use = (Dalc + Walc) / 2)

dat3$high_use <- dat3$alc_use > 2

old_x <- grep(".x", names(dat3), fixed = TRUE)
old_y <- grep(".y", names(dat3), fixed = TRUE)

names(dat3)[old_x]
names(dat3)[old_y]

# Remove duplicate variables
dat3 <- dat3[,c(-old_x, -old_y)]

names(dat3) %in% c(".x", ".y") %in%  names(dat3)

# Select variables with no .x or .y (join variables and aggregates)
glimpse(dat3)

# Write joined data to new csv
setwd("data")
write.csv(dat3, "student_alc.csv")
