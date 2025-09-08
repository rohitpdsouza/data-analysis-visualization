library(tidyverse)

# (I) Tidy data
# There are three interrelated rules that make a dataset tidy:
# 1. Each variable is a column; each column is a variable.
# 2. Each observation is a row; each row is an observation.
# 3. Each value is a cell; each cell is a single value.

# tidyr provides two functions for pivoting data: pivot_longer() and pivot_wider()

#(II) Pivot long

# pivot your data into a tidy form, with variables in the columns and observations in the rows

#The billboard dataset records the billboard rank of songs in the year 2000
# columns names are one variable (week) and cell values are another variable (rank)

# A tibble: 317 × 79
# artist      track date.entered   wk1   wk2   wk3   wk4   wk5   wk6   wk7   wk8   wk9  wk10  wk11  wk12  wk13  wk14
# <chr>       <chr> <date>       <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
# 2 Pac       Baby… 2000-02-26      87    82    72    77    87    94    99    NA    NA    NA    NA    NA    NA    NA
# 2Ge+her     The … 2000-09-02      91    87    92    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA

billboard_pivot <- billboard |> 
  pivot_longer(
    cols = starts_with("wk", ignore.case = TRUE),  # untidy data in columns wk
    #cols = !c(artist, track, date.entered) # another way to select columns that you wish to tidy
    names_to = "week",   #all columns starting with "wk" will pivot to single column week
                         #wk1/wk2...will become values for the column
    values_to = "rank",  #values in the cell for all "wk" columns will become values for the variable "rank"
    values_drop_na = TRUE
  ) |>
  mutate(
    week = parse_number(week)
  )

# A tibble: 5,307 × 5
# artist  track                   date.entered  week  rank
# <chr>   <chr>                   <date>       <dbl> <dbl>
# 2 Pac   Baby Don't Cry (Keep... 2000-02-26       1    87
# 2 Pac   Baby Don't Cry (Keep... 2000-02-26       2    82
# 2 Pac   Baby Don't Cry (Keep... 2000-02-26       3    72
# 2 Pac   Baby Don't Cry (Keep... 2000-02-26       4    77
# 2 Pac   Baby Don't Cry (Keep... 2000-02-26       5    87
# 2 Pac   Baby Don't Cry (Keep... 2000-02-26       6    94
# 2 Pac   Baby Don't Cry (Keep... 2000-02-26       7    99
# 2Ge+her The Hardest Part Of ... 2000-09-02       1    91
# 2Ge+her The Hardest Part Of ... 2000-09-02       2    87
# 2Ge+her The Hardest Part Of ... 2000-09-02       3    92

billboard_pivot |>
  ggplot(aes(x = week, y = rank, group = track)) + ## plot the line for 1 track showing the rank by week
  geom_line(alpha = 0.25) +
  scale_y_reverse() # reverse the direction of the y axis
                    # ranks - lower numbers (better ranks) at the top
                    # depth - ocean depth , deeeper values at the bottom



#who2 contains tuberculosis observations with multiple information crammed into column names: 
#column names are a combination of multiple variables: diagnosis method, gender and age


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
  
#household contains column names which are a mix of variables (name, dob) and values (child1/child2)
# A tibble: 5 × 5
#     family  dob_child1  dob_child2    name_child1   name_child2
#     <int>   <date>      <date>        <chr>         <chr>      
# 1     1     1998-11-26  2000-01-29    Susan         Jose       
# 2     2     1996-06-22  NA            Mark          NA         
# 3     3     2002-07-11  2004-04-05    Sam           Seth       
# 4     4     2004-10-10  2009-08-27    Craig         Khai       
# 5     5     2000-12-05  2005-02-28    Parker        Gracie 

#.value tells pivot_longer that part of the column name should become the name of an existing column in the dataset
#.value will turn "dob" and "name" into column names and "child1" and "child2" as values for the new column "child"
household |>
  pivot_longer(
    cols = !family,
    names_to = c(".value", "child"), #1st component, before the separator, will become the column name
                                     #2nd component, after the separator will become values for the column "child"
    names_sep = "_",
    values_drop_na = TRUE
  )
# A tibble: 9 × 4
# family  child     dob        name  
# <int>   <chr>     <date>     <chr> 
# 1       child1    1998-11-26 Susan 
# 1       child2    2000-01-29 Jose  
# 2       child1    1996-06-22 Mark  
# 3       child1    2002-07-11 Sam   
# 3       child2    2004-04-05 Seth  
# 4       child1    2004-10-10 Craig 
# 4       child2    2009-08-27 Khai  
# 5       child1    2000-12-05 Parker
# 5       child2    2005-02-28 Gracie

#If say we have 3 parts
household2 <- tibble(
  family = c("Smith", "Jones"),
  income_child1_2020 = c(20000, 25000),
  income_child2_2020 = c(15000, 18000),
  age_child1_2020    = c(12, 14),
  age_child2_2020    = c(10, 9)
)

household2 |> 
  pivot_longer(
    cols = !family,
    names_sep = "_",
    names_to = c(".value","child","year")
  )

#Another powerful way to do this is to specific regex using names_pattern for full control
# . any single character
# * zero or more times
# + one or more times
# \\d digits(0-9)
 
household2 |>
  pivot_longer(
    cols = !family,
    names_pattern = "(.*)_(child\\d)_(\\d+)",
    names_to = c(".value", "child", "year")
  )

# (III) Pivot wide
# Pivot long makes a dataset long by increasing rows and reducing columns
# Pivot wide makes dataset wider by increasing columns and reducing rows when one observation is spread across multiple row

# A tibble: 500 × 5
# org_pac_id org_nm                               measure_cd   measure_title                                prf_rate
# <chr>      <chr>                                <chr>        <chr>                                           <dbl>
# 0446157747 USC CARE MEDICAL GROUP INC           CAHPS_GRP_1  CAHPS for MIPS SSM: Getting Timely Care, Ap…       63
# 0446157747 USC CARE MEDICAL GROUP INC           CAHPS_GRP_2  CAHPS for MIPS SSM: How Well Providers Comm…       87
# 0446157747 USC CARE MEDICAL GROUP INC           CAHPS_GRP_3  CAHPS for MIPS SSM: Patient's Rating of Pro…       86

cms_patient_experience |>
  pivot_wider(
    id_cols = starts_with("org"),
    names_from = measure_cd,
    values_from = prf_rate
  ) 

# A tibble: 95 × 8
# org_pac_id org_nm                         CAHPS_GRP_1 CAHPS_GRP_2 CAHPS_GRP_3 CAHPS_GRP_5 CAHPS_GRP_8 CAHPS_GRP_12
# <chr>      <chr>                                <dbl>       <dbl>       <dbl>       <dbl>       <dbl>        <dbl>
# 0446157747 USC CARE MEDICAL GROUP INC              63          87          86          57          85           24
# 0446162697 ASSOCIATION OF UNIVERSITY PHY…          59          85          83          63          88           22
# 0547164295 BEAVER MEDICAL GROUP PC                 49          NA          75          44          73           12
# 0749333730 CAPE PHYSICIANS ASSOCIATES PA           67          84          85          65          82           24
# 0840104360 ALLIANCE PHYSICIANS INC                 66          87          87          64          87           28
# 0840109864 REX HOSPITAL INC                        73          87          84          67          91           30
# 0840513552 SCL HEALTH MEDICAL GROUP DENV…          58          83          76          58          78           26
# 0941545784 GRITMAN MEDICAL CENTER INC              46          86          81          54          NA           25
# 1052612785 COMMUNITY MEDICAL GROUP LLC             65          84          80          58          87           29
# 1254237779 OUR LADY OF LOURDES MEMORIAL …          61          NA          NA          65          NA           17


## (IV) janitor package

##janitor::clean_names() - to standardize and clean column names in a data frame or tibble
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

df <- data.frame(
  "First Name" = c("Alice", "Bob"),
  "Last Name!" = c("Smith", "Jones"),
  "AGE (Years)" = c(25, 30)
)

janitor::clean_names(df)

##remove_empty() - Removes empty rows and/or columns
df <- data.frame(a = c(1, 2, NA), b = c(NA, NA, NA))
df |> 
  janitor::remove_empty(which = c("cols", "rows"))

## get_dupes() - find duplicate rows
df <- data.frame(id = c(1, 2, 2, 3), name = c("A", "B", "B", "C"))
df |> janitor::get_dupes()

##compare_df_cols() - compare data frame columns and types
df1 <- data.frame(a = 1, b = "x")
df2 <- data.frame(a = 2, c = 5)
janitor::compare_df_cols(df1, df2)

##excel_numeric_to_date() - convert excel numbers to R date
janitor::excel_numeric_to_date(43500)

