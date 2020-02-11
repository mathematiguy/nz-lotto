library(tidyverse)
library(jsonlite)
library(here)
library(furrr)

plan(multiprocess)

results <- read_json(here("lotto/output.json"))

results_data <- results %>%
    future_map(function(res) {
    as_tibble(res) %>%
    select(-results_table) %>%
    distinct() }) %>%
    bind_rows()%>%
    mutate(date = as.Date(date, format = "%d-%B-%Y"),
           number_of_winners = str_remove_all(number_of_winners, ","),
           average_prize_per_winner = str_remove(average_prize_per_winner, "\\$"),
           total_prize_pool = str_remove_all(total_prize_pool, "\\$|,")) %>%
    mutate_at(vars(starts_with("ball"), "bonus", "powerball", starts_with("strike"),
                   "draw_number", "number_of_winners"), as.integer) %>%
    mutate_at(vars("total_prize_pool", "average_prize_per_winner"), as.numeric) %>%
    arrange(draw_number)

division_data <- results %>%
    future_map(function (res) {
    out <- map(res$results_table, as_tibble) %>%
           bind_rows()
    out$draw_number <- rep(res$draw, nrow(out))
    out}) %>%
    bind_rows() %>%
    mutate(matches = matches %>%
    str_trim() %>%
    str_replace_all("\\s{2,}", " "),
    winners = str_remove_all(winners, ","),
    prize = str_remove_all(prize, "\\$|,"),
    payout = str_remove_all(payout, "\\$|,"),
    free_ticket = is.na(as.numeric(prize))) %>%
    mutate_at(vars("division", "winners", "draw_number"), as.integer) %>%
    mutate_at(vars("prize", "payout"), as.numeric) %>%
    mutate(prize = if_else(is.na(prize), 0, prize),
           game = case_when(
                str_detect(matches, "Powerball") ~ "powerball",
                str_detect(matches, "Exact") ~ "strike",
                TRUE ~ "lotto")) %>%
    arrange(draw_number)

results_data <- write_csv(results_data, here("data/results_data.csv"))
division_data <- write_csv(division_data, here("data/division_data.csv"))

