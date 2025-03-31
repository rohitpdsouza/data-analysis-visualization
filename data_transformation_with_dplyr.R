library(tidyverse)
library(palmerpenguins)
library(nycflights13)


#dplyr overwrites some functions in base R. 
#If you want to use the base version of these functions after loading dplyr, you’ll need to use their full names: stats::filter() and stats::lag()
#packagename::functionname() stats::filter() and stats::lag()


##Tibbles
#tibble, a special type of data frame used by the tidyverse to avoid some common gotchas
#they are designed for large datasets

#only show the first few rows and columns. There are a few options to see everything
#RStudio : View(flights)
#print(flights, width = Inf)
#glimpse(flights)



# dplyr's verbs are organized in 4 groups based on the objects they operate on: row, column, group, table

# I) ROWS

flights |> filter(dep_delay > 120)

#flights that departed on January 1
flights |> filter(month == 1, day == 1)

#flights that departed in January or february
flights |> 
  filter(month == 1 | month == 2)

#flights that departed in January or february
flights |>
  filter(month %in% c(1,2))

#Store jan1 flights
jan1 <- flights |>
  filter(month == 1 & day = 1)

#2 different ways to write AND condition
flights |> 
  filter(day == 1, month == 1)

flights |>
  filter(day == 1 & month == 1)


# arrange to order
leastdelayed <- flights |>
  arrange(dep_delay)

mostdelayed <- flights |>
  arrange(desc(dep_delay))

# Distinct to remove duplicates
flights |> 
  distinct()

#Find all unique origin and destination pairs
uniquepaths <- flights |>
  distinct(origin, dest)

##Find all unique origin and destination pairs and keep all columns of the 1st occurance in row
uniquepaths_all_attributes <- flights |> 
  distinct(origin, dest, .keep_all = TRUE)

# total number of flights
flights |> 
  count()

# number of flights between source and destination, sorted
flight_path_freq <- flights |>
  count(origin, dest, sort = TRUE)




## Exercise

#1)
# In a single pipeline for each condition, find all flights that meet the condition:
# # Had an arrival delay of two or more hours (arr_delay)
# Flew to Houston (IAH or HOU) (dest)
# Were operated by United, American, or Delta (carrier)
# Departed in summer (July, August, and September) (month)
# Arrived more than two hours late but didn’t leave late (arr_delay, dep_delay)
# Were delayed by at least an hour, but made up over 30 minutes in flight (dep_delay , arr_time, sched_arr_time)

flights |> 
  filter((arr_delay >= 120) & 
             (dest %in% c("IAH","HOU")) & 
             (carrier %in% c("UA","AA","DL")) &
             (month %in% c(7, 8, 9)) &
             (arr_delay > 120 & dep_delay <= 0) & 
             (dep_delay >= 60 & arr_delay < dep_delay - 30)) |>
  count()



# Sort flights to find the flights with the longest departure delays. 
flights |> arrange(desc(dep_delay)) |>
  head(10)

# Find the flights that left earliest in the morning.  
flights |> arrange(dep_time) |>
  head(10)

# Sort flights to find the fastest flights
flights |> arrange((arr_time - dep_time))


#Was there a flight on every day of 2013?
flights |> distinct(year, month, day) |> 
  count()

#Which flights traveled the farthest distance? 
flights |> arrange(desc(distance)) |>
  head(10)



#### (II) COLUMNS#####

# There are four important verbs that affect the columns without changing the rows: 
# 1) mutate() creates new columns that are derived from the existing columns 
# 2) select() changes which columns are present
# 3) rename() changes the names of the columns
# 4) relocate() changes the positions of the columns.


# 1) mutate
flights |> 
  mutate( 
    gain = dep_delay - arr_delay,
    speed = distance / (air_time * 60)
    )

flights |> 
  mutate( 
    gain = dep_delay - arr_delay,
    speed = distance / (air_time * 60),
    .before = 1  #new columns will be added to the left
  )

flights |> 
  mutate( 
    gain = dep_delay - arr_delay,
    speed = distance / (air_time * 60),
    .after = day  #new columns will be added after the day column
  )

flights |> 
  mutate( 
    gain = dep_delay - arr_delay,
    speed = distance / (air_time * 60),
    .before = day  #new columns will be added before the day column
  )

flights |> 
  mutate( 
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours,  
    .keep = "used" #only columns involved or computed will be kept
  )


# 2) Select
flights |> 
  select(year, month, day) #select columns by name 

flights |> 
  select(year:day) #select all columns between year and day (inclusive of year and day)

flights |>
  select(!year:day) # select all columns except those between year and day(inclusive of year and day)

flights |>
  select(where(is.character)) # select all columns that are character

# useful fuctions: 
# starts_with("abc"): matches names that begin with “abc”.
# ends_with("xyz"): matches names that end with “xyz”.
# contains("ijk"): matches names that contain “ijk”.
# num_range("x", 1:3, width = 1): to select multiple columns with names that follow a consistent numerical pattern
# any_of() allows you to safely select columns even if some are missing. 

flights |>
  select(tail_num = tailnum) #rename tailnum to tail_num

########## 3) rename

flights |>
  rename(tail_num = tailnum) # keep all the existing variables and just rename tailnum 


#janitor::clean_names() to standardize and clean column names in a data frame or tibble
# It applies consistent formatting by:
# - Converting names to lowercase.
# - Replacing spaces and special characters with underscores.
# - Removing leading or trailing whitespace.
# - Ensuring names start with a letter.
# - Making the names R-friendly and consistent.

# janitor::clean_names(dat, case = "snake")
# dat: The dataframe or tibble you want to clean.
# case: The desired casing format:
# "snake" → my_variable_name (default)
# "lower_camel" → myVariableName
# "upper_camel" → MyVariableName
# "screaming_snake" → MY_VARIABLE_NAME
# "lower_upper" → myVARIABLEname
# "upper_lower" → MYvariableNAME

# 4) relocate
flights |>
  relocate(time_hour, air_time) |> # move time_hour and air_time to the front
  glimpse()

flights |> 
  relocate(year:dep_time, .after = time_hour) |> #move all columns between and including year and dep_time after time_hour
  glimpse()

flights |>
  relocate(starts_with("arr"), .before = dep_time) |>
  glimpse()

## Exercise

# Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?
flights |> 
  select(contains("dep_")) |>
  glimpse()

flights |> 
  select(dep_time, sched_dep_time, dep_delay) |>
  mutate(calculated_delay = 
           (((dep_time %/% 100) * 60) + (dep_time %% 100)) - 
           (((sched_dep_time %/% 100) * 60) + (sched_dep_time %% 100))
           ) |>
  filter(dep_delay != calculated_delay)


# ignore case with contains
flights |> select(contains("TIME")) #case agnostic
flights |> select(contains("TIME", ignore.case = FALSE)) #case sensitive


#Rename air_time to air_time_min to indicate units of measurement and move it to the beginning of the data frame.
flights |> 
  rename(air_time_min = air_time) |> 
  relocate(air_time_min, .before = 1)

## (III) Pipe

#find the fastest flights to Houston’s IAH airport
flights |>
  filter(dest == "IAH") |>
  mutate(speed = (distance / (air_time / 60))) |>
  select(origin, dest, distance, carrier, flight, air_time, speed) |>
  arrange(desc(speed)) |>
  head(10)

## (IV) Groups

# (IV.1) group_by()
flights |>
  group_by(month) #subsequent operations will now work “by month”

# (IV.2) summarize()
#reduces the data frame to have a single row for each group
flights |>
  group_by(month) |>
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), #average delay per month
    n = n() #flights per month
  )


# (IV.3) slice_ functions
# 1) df |> slice_head(n = 1) take the 1st row from each group
# 2) df |> slice_tail(n = 1) take the last row from each group 
# 3) df |> slice_min(x, n = 1) take the row with smallest value of column x
# 4) df |> slice_max(x, n = 1) take the row with the largest value of column x
# 5) df |> slice_sample(n = 1) takes one random row 
# 
# Note:
# 1) You can vary n to select more than 1 row
# 2) Instead of n, you can use prop = 0.1 to take 10% of the rows in each group
# 3) slice_min and slice_max keep ties by default. If you want exactly one row per group set with_ties = FALSE 

# flights that are most delayed upon arrival at each destination
flights |>
  group_by(dest) |>
  slice_max(arr_delay, n = 1, with_ties = FALSE) |> # top 2 flights, ties then pick 1
  relocate(dest, arr_delay) 

#(IV.4) Group by multiple variables
daily <- flights |>
  group_by(year, month, day)

daily |>
  summarize(n = n()) #summarize will drop the last group (day) by default. 
                     #successive operations will work on group (year,month)

daily |>
  summarize(n = n(), .groups = "drop_last") #drop last group , i.e. default action

daily |>
  summarize(n = n(), .groups = "drop") #drop all group, ungroup the tibble

daily |>
  summarize(n = n(), .groups = "keep") #keep all groups 

# (V) Ungroup
#Removes grouping from a data frame after summarize. 
#The original data frame is still grouped unless re-assigned with ungrouped
#Use .group="drop" in summarize when the original data frame was created if you want no groups in the original data frame 

daily <- flights |>
  group_by(year, month, day)

daily_flight_count <- daily |>
  summarize(n = n())

daily_flight_count |>
  ungroup()

# (VI) .by / by
#group_by and summarize both do persistent grouping

transactions <- tibble(
  company = c("A", "A", "A", "B", "B", "B"),
  year = c(2019, 2019, 2020, 2021, 2023, 2023),
  revenue = c(20, 50, 4, 10, 12, 18)
)
# A tibble: 6 × 3
# company    year     revenue
# <chr>      <dbl>    <dbl>
# 1 A        2019      20
# 2 A        2019      50
# 3 A        2020       4
# 4 B        2021      10
# 5 B        2023      12
# 6 B        2023      18


transactions |>
  group_by(company, year) |>
  mutate(total = sum(revenue))
# A tibble: 6 × 4
# Groups:   company, year [4]
# company    year     revenue total
# <chr>      <dbl>    <dbl>   <dbl>
# 1 A        2019      20      70
# 2 A        2019      50      70
# 3 A        2020       4       4
# 4 B        2021      10      10
# 5 B        2023      12      30
# 6 B        2023      18      30

transactions |>
  group_by(company, year) |>
  summarize(total = sum(revenue))
# `summarise()` has grouped output by 'company'. You can override using the `.groups` argument.
# # A tibble: 4 × 3
# # Groups:   company [2]
# company    year    total
# <chr>      <dbl>   <dbl>
# 1 A        2019    70
# 2 A        2020     4
# 3 B        2021    10
# 4 B        2023    30

#.by uses per-operation grouping 
transactions |>
  mutate(total = sum(revenue), .by = c(company, year))
# A tibble: 6 × 4
# company    year    revenue total
# <chr>      <dbl>   <dbl>   <dbl>
# 1 A        2019      20    70
# 2 A        2019      50    70
# 3 A        2020       4     4
# 4 B        2021      10    10
# 5 B        2023      12    30
# 6 B        2023      18    30

transactions |>
  summarize(total = sum(revenue), .by = c(company, year))
# A tibble: 4 × 3
# company    year    total
# <chr>      <dbl>   <dbl>
# 1 A        2019    70
# 2 A        2020     4
# 3 B        2021    10
# 4 B        2023    30

#NOTE: .by doesn’t sort grouping keys. 
#group_by() always sorts keys in ascending order, which affects the results of verbs like summarise()

transactions <- tibble(
  company = c("A", "A", "A", "B", "B", "B"),
  year = c(2019, 2019, 2020, 2021, 2023, 2023),
  revenue = c(20, 50, 4, 10, 12, 18)
)

transactions2 <- transactions |>
  arrange(company, desc(year))
# A tibble: 6 × 3
# company    year     revenue
# <chr>      <dbl>    <dbl>
# 1 A        2020       4
# 2 A        2019      20
# 3 A        2019      50
# 4 B        2023      12
# 5 B        2023      18
# 6 B        2021      10

transactions2 |>
  group_by(company, year) |>
  summarize(total = sum(revenue), .groups = "drop")
#group by re-ordered (it always yields output in ascending order of the group columns)
# A tibble: 4 × 3
# company    year   total
# <chr>      <dbl>  <dbl>
# 1 A        2019    70
# 2 A        2020     4
# 3 B        2021    10
# 4 B        2023    30

transactions2 |>
  summarize(total = sum(revenue), .by = c(company, year))  #.by respects the original order 

# A tibble: 4 × 3
# company    year   total
# <chr>     <dbl>   <dbl>
# 1 A        2020     4
# 2 A        2019    70
# 3 B        2023    30
# 4 B        2021    10


##Exercise

# 1) Which carrier has the worst average delays? 
#Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not?
flights |>
  summarize(average_delay = mean(arr_delay, na.rm = TRUE), .by = carrier) |>
  arrange(desc(average_delay))

flights |>
  group_by(carrier, dest) |>
  summarize(n=n())

# 2) Find the flights that are most delayed upon departure from each destination.
# group by dest
# order by dep_delay desc, pick the top 1  Or slice_max
flights |>
  group_by(dest) |>
  slice_max(dep_delay, n =1, with_ties = FALSE, na_rm=TRUE) |>
  relocate(dest, dep_delay)

#3) How do delays vary over the course of the day? Illustrate your answer with a plot.
flights_by_hour <- flights |>
  group_by(hour) |>
  summarize(mean_dep_delay = mean(dep_delay, na.rm = TRUE)) |>
  arrange(hour)

ggplot(flights_by_hour, aes(x = hour, y = mean_dep_delay)) + 
  geom_point() + 
#  geom_line() +
  geom_smooth(method = "loess", se = FALSE)


#4) What happens if you supply a negative n to slice_min()
df <- tibble(
  name = c("Alice", "Bob", "Charlie", "Dexter", "Alan"),
  score = c(80, 90, 74, 55, 92)
)

df |> slice_min(score, n = -1)
#removes 92 
#keeps all and removes the largest score

#5) Explain what count() does in terms of the dplyr verbs you just learned. 
#What does the sort argument to count() do?

#count will automatically group by the selected columns and summarize the number of observations for each group
#sort = TRUE will show the highest count first and lowest count last

flights |>
  count(origin, sort = TRUE)


## CASE STUDY : BATTERS
#plot the skill of the batter (measured by the batting average, performance) 
#against the number of opportunities to hit the ball (measured by times at bat, n)

batters <- Lahman::Batting |>
  group_by(playerID) |>
  summarize(
    performance = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    n = sum(AB, na.rm= TRUE)        
  )

batters |> 
  filter(n > 100) |>
  ggplot(aes(x = n, y = performance)) +
  geom_point(alpha = 0.1) + 
  geom_smooth(method = "auto", se = FALSE)






