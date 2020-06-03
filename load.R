library(tidyverse)
library(janitor)

library(helpers)

## NB: uncomment to download/update yearly summaries
#source("scripts/download-annual-summaries.R")

returns <- fs::dir_ls("data/source/ongov-fir/comprehensive/", glob = "*.zip") %>%
  map_df(read_csv, .id = "source_file") %>%
  clean_names
