source("load.R")

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

ottawa_sched_40_2018 <- returns %>%
  filter(marsyear == 2018) %>%
  filter(municipality_desc == "Ottawa C") %>%
  filter(schedule_desc == "CONSOLIDATED STATEMENT OF OPERATIONS: EXPENSES") %>%
  remove_extra_columns() %>%
  mutate(is_subtotal_entry = schedule_line_desc %in% sched_40_groups) %>% ## TODO: do this with detect 99 in `slc` instead
  mutate(expense_group = ifelse(is_subtotal_entry, schedule_line_desc, NA_character_)) %>%
  select(expense_group, everything()) %>%
  fill(expense_group, .direction = "up") %>%
  mutate(is_total_entry = schedule_line_desc == "Total")

ottawa_sched_40_2018

ottawa_sched_40_2018 %>%
  filter(! is_subtotal_entry & ! is_total_entry) %>%
  filter(schedule_column_desc == "Total Expenses After Adjustments") %>%
  mutate(spend_pct = amount / sum(amount)) %>%
  select(schedule_line_desc, spend = amount, spend_pct) %>%
  arrange(-spend_pct)




sched_40_2018 <- returns %>%
  filter(marsyear == 2018) %>%
  filter(schedule_desc == "CONSOLIDATED STATEMENT OF OPERATIONS: EXPENSES") %>%
  remove_extra_columns() %>%
  mutate(is_subtotal_entry = schedule_line_desc %in% sched_40_groups) %>% ## TODO: do this with detect 99 in `slc` instead
  mutate(expense_group = ifelse(is_subtotal_entry, schedule_line_desc, NA_character_)) %>%
  group_by(municipality_desc) %>%
  select(expense_group, everything()) %>%
  fill(expense_group, .direction = "up") %>%
  mutate(is_total_entry = schedule_line_desc == "Total")

sched_40_2018 %>% filter(tier_code == "ST") %>%
  filter(! is_subtotal_entry & ! is_total_entry) %>%
  filter(schedule_column_desc == "Total Expenses After Adjustments") %>%
  mutate(spend_pct = amount / sum(amount)) %>%
  select(schedule_line_desc, spend = amount, spend_pct) %>%
  arrange(-spend_pct) %>%
  filter(municipality_desc %in%
           (sched_40_2018 %>%
              filter(schedule_line_desc == "Police") %>%
              select(municipality_desc) %>%
              unique() %>%
              pull()
            )
         ) %>%
  filter(schedule_line_desc == "Police") %>%
  View()

