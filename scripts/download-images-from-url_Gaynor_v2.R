### Downloading images based on URL
## Kaitlyn Gaynor, June 2020

library(tidyverse)
library(here)
library(camtrapR)

setwd("D:/PapersInProcess/GoldStandard_SnapshotSafari/Samples/MTZ")

# bring in consensus samples - there are three columns for URLs of the three images
samples <- read.csv("MTZ_GoldStandard_DataEntry.csv")

# make blank columns into NA so they can be dropped later; also rename so they can be used in the file names
samples <- samples %>% 
    mutate(img1 = na_if(url1, ""),
           img2 = na_if(url2, ""),
           img3 = na_if(url3, ""))

# get it so that each image is in its own row; add column for number
samples_long <- pivot_longer(samples,
                             cols = c(img1, img2, img3),
                             names_to = "image_seq",
                             values_to = "url",
                             values_drop_na = TRUE)

# make url a character string
samples_long$url <- as.character(samples_long$url)

# combine season, site, roll, capture and image_seq so each row has unique name (to be used as file name)
samples_long$file_name <- paste(samples_long$site,
                                samples_long$roll,
                                samples_long$capture,
                                samples_long$image_seq,
                                sep = "_")
# add .jpeg extension
samples_long$file_name <- paste(samples_long$file_name, ".jpeg", sep = "")

# download all images to hard drive. you first need to create the "downloaded-images" file in this R project folder (working directory)
mapply(download.file, 
       samples_long$url, 
       destfile = here::here("downloaded-images", 
                             basename(samples_long$file_name))) 

# then sort them into folders manually based on species (if you want; or just put in one dummy species folder) 
# and come back to this script to generate a csv with the date, time, file name, species, which you can export and populate with other columns 

# generate record table
records <- recordTable(inDir = here::here("downloaded-images"),
                       IDfrom = "directory",
                       timeZone = "Africa/Maputo", # or change to wherever site is; or it doesn't really matter, since we don't need this info
                       removeDuplicateRecords = FALSE)

# export csv
write_csv(records, here::here("data", "records.csv"))


