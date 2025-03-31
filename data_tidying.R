library(tidyverse)
library(palmerpenguins)
library(nycflights13)

# (I) Tidy data
# There are three interrelated rules that make a dataset tidy:
# 1. Each variable is a column; each column is a variable.
# 2. Each observation is a row; each row is an observation.
# 3. Each value is a cell; each cell is a single value.

# pivot your data into a tidy form, with variables in the columns and observations in the rows
# tidyr provides two functions for pivoting data: pivot_longer() and pivot_wider()

#The billboard dataset records the billboard rank of songs in the year 2000

billboard_pivot <- billboard |> 
  pivot_longer(
    cols = starts_with("wk", ignore.case = TRUE),  # untidy data in columns wk
    #cols = !c(artist, track, date.entered) # another way to select columns that you wish to tidy
    names_to = "week",   #
    values_to = "rank",
    values_drop_na = TRUE
  ) |>
  mutate(
    week = parse_number(week)
  )

billboard_pivot |>
  ggplot(aes(x = week, y = rank, group = track)) + ## plot the line for 1 track showing the rank by week
  geom_line(alpha = 0.25) +
  scale_y_reverse() # reverse the direction of the y axis
                    # ranks - lower numbers (better ranks) at the top
                    # depth - ocean depth , deeeper values at the bottom



#who2 contains tuberculosis observations with multiple information crammed into column names: 
#diagnosis method, gender and age


# A tibble: 7,240 × 58
# country      year sp_m_014 sp_m_1524 sp_m_2534 sp_m_3544 sp_m_4554 sp_m_5564 sp_m_65 sp_f_014 sp_f_1524 sp_f_2534
# <chr>       <dbl>    <dbl>     <dbl>     <dbl>     <dbl>     <dbl>     <dbl>   <dbl>    <dbl>     <dbl>     <dbl>
# 1 Afghanistan  1980       NA        NA        NA        NA        NA        NA      NA       NA        NA        NA
# 2 Afghanistan  1981       NA        NA        NA        NA        NA        NA      NA       NA        NA        NA
# 3 Afghanistan  1982       NA        NA        NA        NA        NA        NA      NA       NA        NA        NA
# 4 Afghanistan  1983       NA        NA        NA        NA        NA        NA      NA       NA        NA        NA
# 5 Afghanistan  1984       NA        NA        NA        NA        NA        NA      NA       NA        NA        NA
# 6 Afghanistan  1985       NA        NA        NA        NA        NA        NA      NA       NA        NA        NA
# 7 Afghanistan  1986       NA        NA        NA        NA        NA        NA      NA       NA        NA        NA
# 8 Afghanistan  1987       NA        NA        NA        NA        NA        NA      NA       NA        NA        NA
# 9 Afghanistan  1988       NA        NA        NA        NA        NA        NA      NA       NA        NA        NA
# 10 Afghanistan  1989       NA        NA        NA        NA        NA        NA      NA       NA        NA        NA
# ℹ 7,230 more rows
# ℹ 46 more variables: sp_f_3544 <dbl>, sp_f_4554 <dbl>, sp_f_5564 <dbl>, sp_f_65 <dbl>, sn_m_014 <dbl>,
#   sn_m_1524 <dbl>, sn_m_2534 <dbl>, sn_m_3544 <dbl>, sn_m_4554 <dbl>, sn_m_5564 <dbl>, sn_m_65 <dbl>,
#   sn_f_014 <dbl>, sn_f_1524 <dbl>, sn_f_2534 <dbl>, sn_f_3544 <dbl>, sn_f_4554 <dbl>, sn_f_5564 <dbl>,
#   sn_f_65 <dbl>, ep_m_014 <dbl>, ep_m_1524 <dbl>, ep_m_2534 <dbl>, ep_m_3544 <dbl>, ep_m_4554 <dbl>,
#   ep_m_5564 <dbl>, ep_m_65 <dbl>, ep_f_014 <dbl>, ep_f_1524 <dbl>, ep_f_2534 <dbl>, ep_f_3544 <dbl>,
#   ep_f_4554 <dbl>, ep_f_5564 <dbl>, ep_f_65 <dbl>, rel_m_014 <dbl>, rel_m_1524 <dbl>, rel_m_2534 <dbl>, …
# ℹ Use `print(n = ...)` to see more rows


who2 |>
  pivot_longer(
    cols = !c(country, year),
    names_to = c("diagnosis", "gender", "age_range"),
    names_sep = "_",
    values_to = "count",
    values_drop_na = TRUE
  ) |>
  mutate(
    age_range = case_when(
      age_range == "014" ~ "0014",
      age_range == "65"  ~ "6500",
      TRUE ~ age_range
    )   
  ) |>
  mutate(
    age_range_lower = substr(age_range, 1, 2),
    age_range_higher = substr(age_range, 3, 4)
  ) |>
  mutate(
    age_range_lower = as.integer(age_range_lower),
    age_range_higher = as.integer(age_range_higher)
  ) |>
  select(!age_range) |>
  relocate(count, .after = age_range_higher)

# A tibble: 76,046 × 7
# country         year    diagnosis gender  age_range_lower age_range_higher  count
# <chr>           <dbl>   <chr>     <chr>            <int>            <int>   <dbl>
# 1 Afghanistan   1997    sp        m                    0               14     0
# 2 Afghanistan   1997    sp        m                   15               24    10
# 3 Afghanistan   1997    sp        m                   25               34     6
# 4 Afghanistan   1997    sp        m                   35               44     3
# 5 Afghanistan   1997    sp        m                   45               54     5
# 6 Afghanistan   1997    sp        m                   55               64     2
# 7 Afghanistan   1997    sp        m                   65                0     0
# 8 Afghanistan   1997    sp        f                    0               14     5
# 9 Afghanistan   1997    sp        f                   15               24    38
# 10 Afghanistan  1997    sp        f                   25               34    36
# ℹ 76,036 more rows
# ℹ Use `print(n = ...)` to see more rows
  


