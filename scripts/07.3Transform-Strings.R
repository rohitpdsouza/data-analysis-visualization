# We will use functions from the stringr package, which is part of the core tidyverse
# We will use the babynames data since it provides some fun strings to manipulate
library(tidyverse)
library(babynames)

#all stringr functions start with str_. 
#This is particularly useful if you use RStudio because typing str_ will trigger autocomplete, allowing you to jog your memory of the available functions.

# (I) Creating a string
string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'

# (II) Escapes
double_quote <- "\""
single_quote <- "\'"
str_view(double_quote)
#The printed representation of a string is not the same as the string itself because the printed representation shows the escapes
#To see the raw contents of the string, use str_view()

#To eliminate escaping, use raw string
#A raw string usually starts with r"( and ends with )". You can use r"[]" or r"{}" or r"--()--" , any number of dashes
tricky <- r"(double_quote <- "\"")"
str_view(tricky) 


# (III) str_ functions

# (III.1) str_c()
# str_c() takes any number of vectors as argument and returns a character vector
str_c("Hello ", c("John","Susan"))
coalesce(str_c("Hello ", c("John","Susan", NA),"!"),"Hello!")

# (III.2) str_flatten()
#Always returns a single string 
df <- tribble(
  ~name, ~fruit,
  "Carmen", "banana",
  "Carmen", "apple",
  "Melvin", "pear",
  "Melvin", "orange",
  "Melvin", "papaya"
)

df |>
  group_by(name) |>
  summarize(fruits = str_flatten(fruit, ", "))

#(IV) Extracting data from strings

#(IV.1) Separating into rows
#separate_longer_delim - by delimiter
#separate_longer_position - by fixed position

df <- tibble(x = c("a,b,c", "d,e", "f"))
df |> 
  separate_longer_delim(x, delim=",")
# separate_longer_delim(x, ",")

df <- tibble(x = c("1123","131","21"))
df |>
  separate_longer_position(x, width = 1)

#(IV.2) Separating into columns
#separate_wider_delim - by delimiter
#separate_wider_position - by position 

df <- tibble(x = c("a10.v1.2022", "b1003.v2.2024", "e15.v5.2025"))
df |> 
  separate_wider_delim(
    x,    #split column x in df
    delim = ".",
    names = c("code", "version", "year")
  )

df <- tibble(x = c("202215TX", "201128LA"))
df |> 
  separate_wider_position(
  x,
  widths = c(year = 4, age = 2, state = 2)
)





