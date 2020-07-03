library(tidyverse)
library(janitor)

library(helpers)

## NB: uncomment to download/update yearly summaries
#source("scripts/download-annual-summaries.R")

## source: https://efis.fma.csc.gov.on.ca/fir/MultiYearReport/Documentation%20for%20CSV%20files.pdf
mtypes <- tibble(
  mtype_code = c(0, 1, 3, 4, 5, 6),
  mtype_label = c(
    "Upper Tier",
    "City",
    "Separated Town",
    "Town",
    "Village",
    "Township"
  )
)

returns <- fs::dir_ls("data/source/ongov-fir/comprehensive/", glob = "*.zip") %>%
  map_df(read_csv, .id = "source_file") %>%
  clean_names %>%
  separate(
    slc,
    into = c("dropme", "schedule", "line", "section", "column"),
    sep = "\\.",
    remove = FALSE
  ) %>%
  select(-dropme) %>%
  mutate(line = str_remove(line, "L")) %>%
  left_join(mtypes) %>%
  select(source_file:mtype_code, mtype_label, everything())
