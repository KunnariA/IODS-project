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


## Week 5

# Convert GNI to numeric
human$GNIn <- as.numeric(gsub(",", ".", human$GNI))

# Select only needed variables
human <- human %>%
  dplyr::select(Country, SecRatio, LabRatio, EduExp, LifeExp, GNIn, 
                MatMortal, AdoBrt, RepPar)

# Remove observations with missing values
human <- na.omit(human)

# Remove the regional observations: "Arab states", "East Asia and the Pacific", 
# "Europe and Central Asia", "Latin America and the Caribbean" "South Asia", 
# "Sub-Saharan Africa", "World"

regions <- c("Arab states", "East Asia and the Pacific", 
             "Europe and Central Asia", "Latin America and the Caribbean", 
             "South Asia", "Sub-Saharan Africa", "World")

human <- human %>% 
  dplyr::filter(!(Country %in% regions))

# Make country names the row names
rownames(human) <- human$Country

# Remove country variable
human <- human %>%
  dplyr::select(-Country)

# Save data as csv
write.csv(human, "human.csv")