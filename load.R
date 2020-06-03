library(tidyverse)
library(readxl)
library(janitor)
library(rvest)

library(helpers)

## NB: uncomment to download/update yearly summaries
#source("scripts/download-annual-summaries.R")

# TODO: make this generic loader for all in folder, use .zip directly (can even write a downloader)
fir2018 <- read_csv("data/source/ongov-fir/comprehensive/fir_data_2018.csv") %>%
  clean_names()

