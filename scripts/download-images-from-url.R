### Downloading images based on URL
## Kaitlyn Gaynor, June 2020

library(tidyverse)
library(here)
library(camtrapR)

# bring in assignment
samples <- read.csv("data/WLD_GoldStandard_DataEntry_kg.csv")

# add index column
samples$index <- c(1:nrow(samples))

# make blank columns into NA so they can be dropped later; also rename so they can be used in the file names
samples <- samples %>% 
    mutate(img1 = na_if(zooniverse_url_0, ""),
           img2 = na_if(zooniverse_url_1, ""))

# get it so that each image is in its own row; add column for number
samples_long <- pivot_longer(samples,
                             cols = c(img1, img2),
                             names_to = "image_seq",
                             values_to = "url",
                             values_drop_na = TRUE)

# make url a character string
samples_long$url <- as.character(samples_long$url)

# combine season, site, roll, capture and image_seq so each row has unique name (to be used as file name)
samples_long$file_name <- paste(samples_long$index,
                                samples_long$site,
                                samples_long$roll,
                                samples_long$capture,
                                samples_long$image_seq,
                                sep = "_")
# add .jpeg extension
samples_long$file_name <- paste(samples_long$file_name, ".jpeg", sep = "")

# download all images to hard drive. you first need to create the "downloaded-images" file in this R project folder (working directory)
mapply(download.file, 
       samples_long$url, 
       destfile = here::here("data/downloaded-images", 
                             basename(samples_long$file_name))) 

# was stalling at index 482 for some reason..... restarted here
samples_long_2 <- filter(samples_long, index >= 482)
mapply(download.file, 
       samples_long_2$url, 
       destfile = here::here("data/downloaded-images", 
                             basename(samples_long_2$file_name)))

# was stalling at index 1294 for some reason..... restarted here (continued this for future resets)
samples_long_3 <- filter(samples_long, index >= 1294)
mapply(download.file, 
       samples_long_3$url, 
       destfile = here::here("data/downloaded-images", 
                             basename(samples_long_3$file_name)))
