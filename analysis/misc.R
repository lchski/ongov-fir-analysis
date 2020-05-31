source("load.R")

ottawa_expenses %>%
  filter(! is_totaling_row) %>%
  group_by(expense_category) %>%
  summarize(spend = sum(total_expenses_after_adjustments)) %>%
  mutate(spend_pct = spend / sum(spend)) %>%
  arrange(-spend_pct)

