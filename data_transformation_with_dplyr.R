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








