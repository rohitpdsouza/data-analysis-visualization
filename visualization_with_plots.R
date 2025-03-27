library(tidyverse)

library(palmerpenguins)

##Bar plots
ggplot(penguins, aes(x = island, fill = species)) + geom_bar()

ggplot(penguins, aes(x = species, fill = island)) + geom_bar()

##to order in frequency of count
ggplot(penguins, aes(x = fct_infreq(species), fill = island)) + geom_bar() 


## to see the relative frequency
ggplot(penguins, aes(x = island, fill = species)) + geom_bar(position="fill")


### Box plot
ggplot(penguins, aes(x = species, y = body_mass_g)) + 
  geom_boxplot(fill="lightgreen", color="black", outlier.size = 3, outlier.color="red") + ##outlier aesthetics 
  geom_jitter(width = 0.3, size = 1, color = "orange", alpha = 0.5) + ##jitter to see individual data points
  labs(title = "Box plot", subtitle = "distribution of penguin body mass by species", 
       x = "Species", y = "Body mass(g)")


### Histogram

ggplot(penguins, aes(x = body_mass_g)) + 
  geom_histogram(binwidth = 100, fill = "skyblue", color = "black") ## use bins = 30 or 50 if unsure about bindwidth

# to add density curve on top of histogram
ggplot(penguins, aes(x = body_mass_g)) + 
  geom_histogram(aes(y = after_stat(density)), binwidth = 200, fill = "skyblue", color = "black") + #normalize y axis for density
  geom_density(color = "red", linewidth = 1) #add density line

### Density plot
ggplot(penguins, aes(x = body_mass_g)) + 
  geom_density()

ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) + # plot by species
  geom_density(linewidth = 1, alpha = 0.3)

ggplot(penguins, aes(x = body_mass_g)) + 
  geom_density(aes(color = species, fill = species), linewidth = 1, alpha = 0.3) + 
  facet_wrap(~species) # facet by species

### Scatter plot
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point(aes(color = species, shape = island)) + 
  geom_smooth(method = "lm", color = "purple")

