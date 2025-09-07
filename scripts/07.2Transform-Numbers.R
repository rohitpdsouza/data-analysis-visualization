library(tidyverse)
library(nycflights13)

# (I) Making numbers from strings

x <- c("1.2", "5.6", "1e3", "5.23")
parse_double(x)

x <- c("$1,234", "USD 35.25", "55%")
parse_number(x)

# (II) counts
flights |> count(dest, sort = TRUE) |> print(n = Inf)

# n() returns the number of rows in the current group when used inside dplyr verbs like summarise() or mutate() after grouping.

#n_distinct() counts of number of unique values of one or more variables
flights |>
  group_by(dest) |>
  summarize(carriers = n_distinct(carrier)) |>
  arrange(desc(carriers))

#weighted count is a sum
flights |> count(tailnum, wt = distance)
#OR
flights |>
  group_by(tailnum) |>
  summarize(miles = sum(distance))

#count missing values using sum and is.na
flights |> 
  group_by(dest) |>
  summarise(n_cancelled = sum(is.na(dep_time)))


#Exercise
#1) use group_by & summarize instead of count
flights |> count(dest, sort = TRUE)

flights |>
  group_by(dest) |>
  summarize(n_dest = n()) |>
  arrange(desc(n_dest))
  
flights |> count(tailnum, wt = distance)

flights |>
  group_by(tailnum) |>
  summarize(
    n_airmiles = sum(distance),
    .groups = "drop"
  ) |>
  #filter(!is.na(tailnum)) |>    #drop flights with missing tailnumber if needed
  arrange(desc(n_airmiles))

#(III) Arithmetic and recycling rules
# R handles mismatched lengths on either side of arithmetic operator by recycling or repeating the shorter vector

x <- c(1, 2, 10, 20)
x / 5
x * c(1, 2)

x * c(1, 2, 3) 
# [1]  1  4 30 20
# Warning message:
#   In x * c(1, 2, 3) :
#   longer object length is not a multiple of shorter object length

#These recycling rules are also applied to logical comparisons (==, <, <=, >, >=, !=) and can lead to a surprising result if you accidentally use == instead of %in% and the data frame has an unfortunate number of rows
# e.g. below attempt to find all flights in January and February
flights |> 
  filter(month == c(1, 2))
#will run without throwing any error but does not give the result we need
# Because of the recycling rules it finds flights in odd numbered rows that departed in January and flights in even numbered rows that departed in February. And unfortunately there’s no warning because flights has an even number of rows.


#(IV) pmin and pmax
#pmin and pmax will perform an element-wise comparison across each row
#It returns a vector which each row gets its own min and max
df <- tribble(
  ~x, ~y, ~z,
  1, 2, 3,
  4, 5, 6,
  7, NA, NA,
)

df |>
  mutate(
    min = pmin(x, y, z, na.rm = TRUE),
    max = pmax(x, y, z, na.rm = TRUE)
  )
# A tibble: 3 × 5
# x     y     z   min   max
# <dbl> <dbl> <dbl> <dbl> <dbl>
# 1     2     3     1     3
# 4     5     6     4     6
# 7    NA    NA     7     7

#(V) Modular arithmetic
# %/% computes the integer (before decimal)
# %% computes the remainder (after decimal)

#The proportion of cancelled flights varies over the course of the day
flights |>
  group_by(hour) |>
  summarize(
    prop_cancelled = mean(is.na(dep_time)),
    n = n()
  ) |>
  filter(n > 1) |>
  ggplot(aes(x = hour, y = prop_cancelled)) +
  geom_line() +
  # geom_text(
  #   aes(label = round(prop_cancelled *100, 2)),
  #   vjust = -2,
  #   hjust = 0.5
  # ) +
  geom_point(
    aes(size = n)
  )

#(VI) Logarithms
log(100)  #e^x = 100
log10(100) #10^x=100
log2(16) #2^x=16
log(64, base = 4) #4^x=64
exp(2) #e^2

#(VII) Rounding
round(1.234, 2) #1.23
round(1.235, 2) #1.24
round(123.456, 1) #123.5
round(123.456, -1) #120
round(123.456, -2) #100
#round() does "round half to even" or Banker's rounding, see below
round(1.5) #2
round(2.5) #2

#ceiling will round up, floor will round down
floor(1.5) #1
floor(2.5) #2
ceiling(1.5) #2  
ceiling(1.4) #2
ceiling(2.5) #3
ceiling(2.3) #3
floor(123.456 / 0.01) * 0.01 #123.45
ceiling(123.456 / 0.01) * 0.01 #123.46




