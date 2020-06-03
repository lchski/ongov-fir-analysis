library(tidvyerse)
library(rvest)

download_annual_summaries <- function() {
  index_dir_url <- "https://efis.fma.csc.gov.on.ca/fir/MultiYearReport/"
  
  index_page <- read_html(paste0(index_dir_url, "MYCIndex.html"))
  
  summary_filenames <- index_page %>%
    html_nodes(xpath = "//a[starts-with(@href, 'fir')]") %>%
    html_attr("href")
  
  summary_urls <- paste0(index_dir_url, summary_filenames)
  
  walk2(
    summary_urls,
    paste0("data/source/ongov-fir/comprehensive/", summary_filenames),
    download.file
  )
}

download_annual_summaries()
