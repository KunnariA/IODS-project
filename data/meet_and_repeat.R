# 1.

library(tidyverse)

URL1 <- "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt"
URL2 <- "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt"

BPRS <- read.table(url(URL1), header=TRUE)
RATS <- read.table(url(URL2), header=TRUE)

dim(BPRS)
names(BPRS)
str(BPRS)

dim(RATS)
names(RATS)
str(RATS)

# 2. Factorize categorical variables

BPRS <- BPRS %>%
  dplyr::mutate(treatment = as.factor(treatment),
                   subject = as.factor(subject))

RATS <- RATS %>%
  dplyr::mutate(Group = as.factor(Group),
                ID = as.factor(ID))
# 3. Long form

BPRS_long <- BPRS %>%
  tidyr::pivot_longer(cols = c(-subject, -treatment), names_to="week")

RATS_long <- RATS %>%
  tidyr::pivot_longer(cols = c(-ID, -Group), names_to="week")

dim(BPRS_long)
names(BPRS_long)
str(BPRS_long)

dim(BPRS_long)
names(RATS_long)
str(RATS_long)

# 4. Understanding the long form

# In wide form, each subject has one row. In long form each measurement 
# point has its own row, thus each respondent has as many rows as there were
# variables to be stacked into the single mega-column. The long form also has
# a new column indicating from which variable a particular value comes.

setwd(paste(getwd(), "/data", sep=""))

write.csv(BPRS_long, "BPRS_long.csv")
write.csv(RATS_long, "RATS_long.csv")
