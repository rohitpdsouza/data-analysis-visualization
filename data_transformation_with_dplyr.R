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

#ROWS

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



#### COLUMNS#####

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





