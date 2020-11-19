# IODS Week 4 Datawrangling
# Anton Kunnari 18.11.2020

library(tidyverse)

# Read 2 datasets (Human development index & Gender inequality index)
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Metadata for datasets:
# http://hdr.undp.org/en/content/human-development-index-hdi
# http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf

dim(hd) # 195 observations, 8 variables
names(hd)

dim(gii) # 195 observations, 12 variables
names(gii)

# Summary statistics for both datasets
psych::describe(hd)
psych::describe(gii)

# Rename variables
names(hd) <- c("Rank", "Country", "HDI", "LifeExp", 
               "EduExp", "MeanEdu", "GNI", "GNIadj")
names(gii) <- c("Rank", "Country", "GII", "MatMortal", "AdoBrt", "RepPar", 
                "FemSecEdu", "MenSecEdu", "FemLabPar", "MenLabPar")

# create 2 new variables: ratios of secondary education and labour participation
# between women and men
gii <- gii %>% 
  mutate(SecRatio = FemSecEdu / MenSecEdu,
         LabRatio = FemLabPar / MenLabPar)

human <- inner_join(hd, gii, by = "Country")

# Save data as csv
write.csv(human, "human.csv")
