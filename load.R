library(tidyverse)
library(readxl)
library(janitor)

library(helpers)

## Schedule 40 "CONSOLIDATED STATEMENT OF OPERATIONS: EXPENSES" from Ottawa
## Excel files from: https://efis.fma.csc.gov.on.ca/fir/ViewFIR2018.htm
## TODO: make this generic loader for all in folder, and extract FY / municipality name from filename
ottawa_expenses <- read_excel(
    "data/source/ongov-fir/cities/FI180614 Ottawa C.xlsx",
    sheet = "40",
    skip = 9,
    col_names = c(
      "expense code",
      "...2",
      "expense category",
      "expense subcategory",
      "...5",
      "Salaries",
      "Interest on\r\nLong Term Debt",
      "Materials",
      "Contracted\r\nServices",
      "Rents and Financial Expenses",
      "External\r\nTransfers",
      "Amortization",
      "Total Expenses\r\nBefore Adjustments",
      "...14",
      "Inter-Functional Adjustments",
      "Allocation of\r\nProgram Support *",
      "Total Expenses\r\nAfter Adjustments",
      "dropme18",
      "dropme19",
      "dropme20",
      "dropme21",
      "dropme22",
      "dropme23",
      "dropme24",
      "dropme25",
      "dropme26",
      "dropme27",
      "dropme28",
      "dropme29",
      "dropme30",
      "dropme31",
      "dropme32",
      "dropme33",
      "dropme34",
      "dropme35"
    ),
    col_types = c(
      "text",
      "skip",
      "text",
      "text",
      "skip",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "skip",
      "numeric",
      "numeric",
      "numeric",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip",
      "skip"
    )
  ) %>%
  clean_names() %>%
  remove_empty(c("rows", "cols")) %>% ## clear out empties from Excel formatting
  remove_extra_columns() %>%
  select(-contains("dropme")) %>%
  mutate(expense_category = str_remove_all(expense_category, fixed(" . "))) %>%
  mutate(expense_category = str_remove(expense_category, " \\.$")) %>%
  mutate(is_totaling_row = str_detect(expense_code, "99")) ## identify all (sub)total rows


fir2018 <- read_csv("data/source/ongov-fir/comprehensive/fir_data_2018.csv") %>%
  clean_names()

