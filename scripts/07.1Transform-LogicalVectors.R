library(tidyverse)
library(nycflights13)

#Logical vectors can have one of three possible values:
# TRUE
# FALSE
# NA


#(I) Comparisons
#(I.1) Another way to find all daytime departures that arrive roughly on time
flights |>
  mutate(
    daytime = dep_time > 0600 & dep_time < 2000,
    approx_ontime = abs(arr_delay) < 20,
    .keep = "used"
  ) |>
  filter(daytime & approx_ontime)

#(I.2) Rounding
x <- c(1 / 49 * 49, sqrt(2) ^ 2)
x
print(x,digits = 16)
near(x, c(1, 2))

x <- c(round(1 / 49 * 49, 0), round(sqrt(2) ^ 2, 0))
x
print(x, digits = 16)

#(I.3) Missing values
#Missing values represent the unknown so they are “contagious”: almost any operation involving an unknown value will also be unknown
is.na(c(TRUE, FALSE, NA))

flights |>
  filter(is.na(dep_time))


#(I.4) %in%
flights |>
  filter(month %in% c(11, 12))


#Exercise
#1) Find all flights where arr_delay is missing but dep_delay is not. 
flights |>
  filter(is.na(arr_delay) & !is.na(dep_delay)) |>
  select(arr_delay, dep_delay)

#2) Find all flights where neither arr_time nor sched_arr_time are missing, but arr_delay is.
flights |>
  filter(!is.na(arr_time) & !is.na(sched_arr_time) & is.na(arr_delay)) |>
  select(arr_time, sched_arr_time, arr_delay)

#3) How many flights have a missing dep_time?
flights |>
  filter(is.na(dep_time)) |>
  count()

#4) Assuming that a missing dep_time implies that a flight is cancelled, look at the number of cancelled flights per day
flights |>
  filter(is.na(dep_time)) |>
  group_by(year, month, day) |>
  summarize(n = n())

#(II) Logical summaries
# any() and all() are two logical summaries

#E.g. 
#If any flight delayed on arrival by 5 hours or more
#If every flight delayed on departure by at most 1 hour
flights |>
  group_by(year, month, day) |>
  summarize(
    any_delay = any(arr_delay >= 300, na.rm = TRUE),
    all_flight_dept_delay = all(dep_delay <= 60, na.rm= TRUE),
    .groups = "drop"
  )

#(III) Numeric summaries
flights |>
  group_by(year, month, day) |>
  summarize(
    delayed_flights = sum(dep_delay <= 60, na.rm = TRUE),
    prop_delay = mean(dep_delay <= 60, na.rm = TRUE),
    long_delay = sum(arr_delay >= 300, na.rm = TRUE)
  )

#(IV) Logical subsetting
flights |>
  group_by(year, month, day) |>
  summarize(
    behind = mean(arr_delay[arr_delay > 0], na.rm = TRUE),
    ahead = mean(arr_delay[arr_delay < 0], na.rm = TRUE),
    n = n(),
    .groups = "drop"
  )

#Exercise
#prod()
data <- c(10, 20, 30, NA)
prod(data, na.rm = TRUE)
prod(data > 10, na.rm = TRUE) #TRUE = 1 FALSE =0


#(V) Conditional Transformations
#(V.1) dplyr::if_else()  
x <- c(-3:3, NA)
if_else(x > 0, "+ve", "-ve", missing = "unknown")

#(V.2) dplyr::case_when()
flights |>
  mutate(
    status = case_when(
      is.na(arr_delay) ~ "cancelled",
      arr_delay < -30 ~ "very early",
      arr_delay < -15 ~ "early",
      abs(arr_delay) <= 15 ~ "on time",
      arr_delay < 60 ~ "late",
      arr_delay < Inf ~ "very late",
      .default = "???"
    ),
    .keep = "used"
  )

#Compatible types
# Numeric and logical vectors are compatible
# Strings and factors are compatible. You can think of a factor as a string with a restricted set of values.
# Dates and date-times are compatible
# NA, which is technically a logical vector, is compatible with everything because every vector has some way of representing a missing value

#Exercise
#1) determine whether each number between 0 and 20 is even or odd
num = c(0:20)
if_else(num%%2 == 0, "Even", "Odd", missing = "???")

#2) label as weekday or weekend
x <- c("Monday", "Saturday", "Wednesday")
if_else(x %in% c("Saturday", "Sunday"), "Weekend", "Weekday", "???")

#3) if_else() to compute the absolute value of a numeric vector called x
x <- c(-5:5)
x
if_else(x < 0, -x, x)

#4) Write a case_when() statement that uses the month and day columns from flights to label a selection of 
# important US holidays (e.g., New Years Day, 4th of July, Thanksgiving, and Christmas). 
# First create a logical column that is either TRUE or FALSE, 
# and then create a character column that either gives the name of the holiday or is NA
calendar <- flights |>
  mutate(
    holiday = case_when(
      is.na(month) | is.na(day) ~ NA,
      month == 1 & day == 1 ~ TRUE,
      month == 7 & day == 4 ~ TRUE,
      month == 11 & day == 27 ~ TRUE,
      month == 12 & day == 25 ~ TRUE,
      .default = FALSE
    ),
    occasion = case_when(
      month == 1 & day == 1 ~ "New Year",
      month  == 7 & day == 4 ~ "Independence Day",
      month == 11 & day == 27 ~ "Thanksgiving",
      month == 12 & day == 25 ~ "Christmas",
      .default = NA
    ),
    .keep = "used"
  ) 

View(calendar)

