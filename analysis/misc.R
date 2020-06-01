source("load.R")

ottawa_expenses %>%
  filter(! is_totaling_row) %>%
  group_by(expense_category) %>%
  summarize(spend = sum(total_expenses_after_adjustments)) %>%
  mutate(spend_pct = spend / sum(spend)) %>%
  arrange(-spend_pct)



# ----


sched_40_groups <- c(
  "General government",
  "Protection services",
  "Transportation services",
  "Environmental services",
  "Health services",
  "Social and family services",
  "Social Housing",
  "Recreation and cultural services",
  "Planning and development"
)

ottawa_sched_40 <- fir2018 %>%
  filter(municipality_desc == "Ottawa C") %>%
  filter(schedule_desc == "CONSOLIDATED STATEMENT OF OPERATIONS: EXPENSES") %>%
  remove_extra_columns() %>%
  mutate(is_subtotal_entry = schedule_line_desc %in% sched_40_groups) %>% ## TODO: do this with detect 99 in `slc` instead
  mutate(expense_group = ifelse(is_subtotal_entry, schedule_line_desc, NA_character_)) %>%
  select(expense_group, everything()) %>%
  fill(expense_group, .direction = "up") %>%
  mutate(is_total_entry = schedule_line_desc == "Total")

ottawa_sched_40

## replicate old analysis methodology done using Excel
ottawa_sched_40 %>%
  filter(! is_subtotal_entry & ! is_total_entry) %>%
  filter(schedule_column_desc == "Total Expenses After Adjustments") %>%
  mutate(spend_pct = amount / sum(amount)) %>%
  select(schedule_line_desc, spend = amount, spend_pct) %>%
  arrange(-spend_pct)

