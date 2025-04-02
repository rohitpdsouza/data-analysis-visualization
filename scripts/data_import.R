library(tidyverse)

#(I)Reading data from a file

#load flat files in R with the readr package, which is part of the core tidyverse

students <- read_csv("https://pos.it/r4ds-students-csv", na = c("N/A", ""))

#use forward slash to read from local path
students <- read_csv("C:/Users/prohi/Documents/Github/data-with-r/data/students.csv", na = c("N/A","")) 
# 
# Rows: 6 Columns: 5                                                                                                 
# ── Column specification ─────────────────────────────────────────────────────────────────────────────────────────────
# Delimiter: ","
# chr (4): Full Name, favourite.food, mealPlan, AGE
# dbl (1): Student ID

students |>
  #janitor::clean_names(case = "snake") |>  #use janitor or rename to clean up column names
  rename(                                   #alternatively use rename for the column names 
    student_id = `Student ID`,
    full_name = `Full Name`,
    favourite_food = favourite.food,
    meal_plan = mealPlan,
    age = AGE
  ) |>
  mutate(
    meal_plan = factor(meal_plan),
    age = parse_number(if_else(age == "five", "5", age))
  )

# read_csv can read text string created and formatted like a csv
read_csv(
  "First metadata line
  Seconnd metadata line
  #by default 1st line is used as column headers/names
  a,b,c   
  1,2,3
  4,5,6",
  skip = 2,       #skip the 1st 2 lines  
  comment = "#",   #use # to drop the comment line
  #col_names = FALSE, #will treat 1st line as record and default column names will be assigned X1, X2
  col_names = c("x","y","z") #specify column names 
)

#(II) Other file types
#read_csv2() reads semicolon-separated files. These use ; instead of , to separate fields 

#read_tsv() reads tab-delimited files.

#read_delim() reads in files with any delimiter, 
#attempting to automatically guess the delimiter if you don’t specify it.

#read_fwf() reads fixed-width files. 
#You can specify fields by their widths with fwf_widths() or by their positions with fwf_positions()

#read_table() reads a common variation of fixed-width files where columns are separated by white space.

#read_log() reads Apache-style log files.

#(III) Controlling column types
#How does readr guess the column types?
# readr uses a heuristic to figure out the column types. 
# For each column, it pulls the values of 1,000 rows spaced evenly from the first row to the last, ignoring missing values. 

# It then works through the following questions:
# Does it contain only F, T, FALSE, or TRUE (ignoring case)? If so, it’s a logical.
# Does it contain only numbers (e.g., 1, -4.5, 5e6, Inf)? If so, it’s a number.
# Does it match the ISO8601 standard? If so, it’s a date or date-time. (We’ll return to date-times in more detail in Section 17.2).
# Otherwise, it must be a string.

read_csv("
  logical,numeric,date,string
  TRUE,1,2021-01-15,abc
  false,4.5,2021-02-15,def
  T,Inf,2021-02-16,ghi
")

#> # A tibble: 3 × 4
#>   logical numeric date       string
#>   <lgl>     <dbl> <date>     <chr> 
#> 1 TRUE        1   2021-01-15 abc   
#> 2 FALSE       4.5 2021-02-15 def   
#> 3 TRUE      Inf   2021-02-16 ghi

simple_csv <- "
  x
  10
  .
  20
  30"

read_csv(simple_csv) # x will be read as a character column due to the .

# # A tibble: 4 × 1
#     x    
#     <chr>
# 1   10   
# 2   .    
# 3   20   
# 4   30   

df <- read_csv(
  simple_csv,
  col_types = list(x = col_double()),
  na = c("NA","N/A",".")
)

problems(df)

#col_logical() and col_double() read logicals and real numbers
#col_integer() reads integers
#col_character() reads strings
#col_factor(), col_date(), and col_datetime() create factors, dates, and date-times
#col_number() is a permissive numeric parser that will ignore non-numeric components, and is particularly useful for currencies
#col_skip() skips a column so it’s not included in the result

#It’s also possible to override the default column by switching from list() to cols() and specifying .default
another_csv <- "
x,y,z
1,2,3"

read_csv(
  another_csv, 
  col_types = cols(.default = col_character())
)

#cols_only() which will read in only the columns you specify:
read_csv(
  another_csv,
  col_types = cols_only(x = col_character())
)


#(IV) Reading data from multiple files

#sales_files <- c("data/01-sales.csv", "data/02-sales.csv", "data/03-sales.csv")
#read_csv(sales_files, id = "file")
