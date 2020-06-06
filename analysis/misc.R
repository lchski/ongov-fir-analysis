source("load.R")






returns %>%
  filter(slc %in% c("slc.80D.L1710.C07.01", "slc.80D.L1720.C07.01")) %>%
  remove_extra_columns() %>%
  select(municipality_desc, marsyear, schedule_line_desc, amount) %>%
  pivot_wider(names_from = schedule_line_desc, values_from = amount) %>%
  clean_names() %>%
  rename(
    paved_km = roads_total_paved_lane_km,
    paved_good_km = condition_of_roads_number_of_paved_lane_kilometres_where_the_con
  ) %>%
  #filter(! is.na(paved_km) & ! is.na(paved_good_km)) %>%
  arrange(municipality_desc, marsyear) %>%
  mutate(pct_good = paved_good_km / paved_km)

