# Anton Kunnari
# 02.11.2020
# Exercise 2 script

library(data.table)
library(tidyverse)



# Read data from internet
URL <- "https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-data.txt"
dat <- read.table(URL, header = TRUE)

dim(dat)  # 183 observations, 60 variables

# Variable names
names(dat)

# Create new variables to data
dat <- dat %>% 
  mutate(Lar = Aa + Ac + Ad,
         Lat = Ab + Ae + Af,
         d_sm = D03 + D11 + D19 + D27,
         d_ri = D07 + D14 + D22 + D30,
         d_ue = D06 + D15 + D23 + D31,
         su_lp = SU02 + SU10 + SU18 + SU26,
         su_um = SU05 + SU13 + SU21 + SU29,
         su_sb = SU08 + SU16+ SU24 + SU32,
         st_os = ST01 + ST09 + ST17 + ST25,
         st_tm = ST04 + ST12 + ST20 + ST28,
         Deep = d_sm + d_ri + d_ue,
         Surf = su_lp + su_um + su_sb,
         Stra = st_os + st_tm)
  
# Subsetting for analysis data 
dat2 <- dat %>% 
  dplyr::select(gender, Age, Attitude, Deep, Stra, Surf, Points) %>%
  dplyr::filter(Points > 0)

setwd("data")
write.csv(dat2, "learning2014.csv", row.names = FALSE)
