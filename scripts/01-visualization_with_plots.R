library(tidyverse)
library(palmerpenguins)
library(nycflights13)

##Bar plots
ggplot(penguins, aes(x = island, fill = species)) + 
  geom_bar()

ggplot(penguins, aes(x = species, fill = island)) + 
  geom_bar()

##to order in frequency of count
ggplot(penguins, aes(x = fct_infreq(species), fill = island)) + 
  geom_bar() 


## to see the relative frequency
ggplot(penguins, aes(x = island, fill = species)) + 
  geom_bar(position="fill")


### Box plot
ggplot(penguins, aes(x = species, y = body_mass_g)) + 
  geom_boxplot(
    fill="lightgreen", 
    color="black", 
    outlier.size = 3,      ##outlier aesthetics
    outlier.color="red"    ##outlier aesthetics
  ) +  
  geom_jitter(             ##jitter to see individual data points
    width = 0.3, 
    size = 1, 
    color = "orange", 
    alpha = 0.5
  ) +  
  labs(
    title = "Box plot", 
    subtitle = "distribution of penguin body mass by species", 
    x = "Species", 
    y = "Body mass(g)"
  )

### Histogram

ggplot(penguins, aes(x = body_mass_g)) + 
  geom_histogram(
    binwidth = 100,      ## use bins = 30 or 50 if unsure about bindwidth 
    fill = "skyblue", 
    color = "black"
  )         

# to add density curve on top of histogram
ggplot(penguins, aes(x = body_mass_g)) + 
  geom_histogram(
    aes(y = after_stat(density)), #normalize y axis for density 
    binwidth = 200, 
    fill = "skyblue", 
    color = "black"
  ) + 
  geom_density(                 #add density line
    color = "red", 
    linewidth = 1
  ) 

### Density plot
ggplot(penguins, aes(x = body_mass_g)) + 
  geom_density()

ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) + # plot by species
  geom_density(
    linewidth = 1, 
    alpha = 0.3
  )

ggplot(penguins, aes(x = body_mass_g)) + 
  geom_density(
    aes(color = species, fill = species), 
    linewidth = 1, 
    alpha = 0.3
  ) + 
  facet_wrap(~species) # facet by species

### Scatter plot
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point(
    aes(color = species, shape = island)
  ) + 
  geom_smooth(
    method = "lm", 
    color = "purple"
  )

### different smooth functions
# auto -> automatically selects the best method based on dataset size
# loess -> locally estimated scatterpoint smoothing. Ideal for small datasets 
# gam -> generalized additive model. ideal for non-linear relationships and large datasets
# lm -> linear model 
# glm -> generalized linear model 
# se parameter TRUE displays 95% confidence interval FALSE hides the confidence interval 

#E.g. variation of delays in flights over the course of the day

flights |> 
  group_by(hour) |>
  summarize(
    n = n(), 
    average_dep_delay = mean(dep_delay, na.rm = TRUE)
  ) |>
  ggplot(aes(x = hour, y = average_dep_delay)) + 
  geom_point() + 
  geom_smooth(
    method = "lm"  ## not useful as delay increase till evening and then reduces hence not linear
  ) 

flights |> 
  group_by(hour) |>
  summarize(
    n = n(), 
    average_dep_delay = mean(dep_delay, na.rm = TRUE)
  ) |>
  ggplot(aes(x = hour, y = average_dep_delay)) + 
  geom_point() + 
  geom_smooth(
    method = "glm"   ## not useful as delay increase till evening and then reduces hence not linear
  ) 

flights |> 
  group_by(hour) |>
  summarize(
    n = n(), 
    average_dep_delay = mean(dep_delay, na.rm = TRUE)
  ) |>
  ggplot(aes(x = hour, y = average_dep_delay)) + 
  geom_point() + 
  geom_smooth(
    method = "loess"  ## non-linear, hence good interpretation 
  ) 

flights |> 
  group_by(hour) |>
  summarize(
    n = n(), 
    average_dep_delay = mean(dep_delay, na.rm = TRUE)
  ) |>
  ggplot(aes(x = hour, y = average_dep_delay)) + 
  geom_point() + 
  geom_smooth(
    method = "gam"   ## good too
  ) 

flights |> 
  group_by(hour) |>
  summarize(
    n = n(), 
    average_dep_delay = mean(dep_delay, na.rm = TRUE)
  ) |>
  ggplot(aes(x = hour, y = average_dep_delay)) + 
  geom_point() + 
  geom_smooth(
    method = "auto"  ## use auto if not sure
  )  


## Save plot
my_bar_plot <- 
  ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point(aes(color = species, shape = island)) + 
  geom_smooth(
    method = "lm", 
    color = "purple"
  )

ggsave(filename = "mpg-plot.png", plot = my_bar_plot)

##Tips

# 2 step process to decide which plot to use:

#Step1:
#What is your goal?
#Compare categories -> Bar chart / column chart / dot plot
#Show distribution -> Histogram / Density plot / Box plot
#Show relationship -> Scatter plot / Line plot / Bubble plot
#Show part to whole -> Pie chart / Stacked bar chart
#Trend over time -> Line plot / Area plot
#Compare distribution -> Box plot / Violin plot
#Show correlation -> Scatter plot with geom_smooth() OR Scatter plot with color

#Step2:
#What types of variables you have?
#One numeric : Histogram / Density plot
#One categorical : Bar chart
#One numeric + one categorical : Box plot / Violin plot / Bar chart
#Two numeric : Scatter plot / Line plot
#Time series : Line plot

#Step3:
#How many variables are you working with?
# 1 variable : use histogram or density plot
# 2 variables : use scatter plot or box plot
# 3+ variables : use color, shape, size, facets to encode the extra variables

