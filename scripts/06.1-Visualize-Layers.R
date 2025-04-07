library(tidyverse)

#(I) Aesthetic mappings

# relationship between displacement and highway miles for various classes of cars

# relationship between 2 numeric variables (eng size in litres and miles) -> use scatterplot
# use facet/shape/size/color to encode class
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  geom_smooth(method = "auto", se = FALSE)

#Note:
#Mapping an un-ordered discrete (categorical) variable (class) to an ordered aesthetic (size or alpha) 
#is generally not a good idea because it implies a ranking that does not in fact exist  


#Group
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(group = drv))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv))

#highlight 2 seater class in a scatter plot
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() +                            #Layer1 all blank points
  geom_point(
    data = mpg |> filter(class == "2seater"),
    color = "red"                           #Layer2 re-plots the 2-seater dots in red
  ) +
  geom_point(
    data = mpg |> filter(class == "2seater"), 
    shape = "circle open",                  #Layer3 plots the open circle, creating the bullseye effect 
    size = 3, 
    color = "red"
  )
#Note:  The below code block will draw red circles around the black dots for 2 seaters.
#       This is because ggplot2 plots layers like transparent stickers stacked on top of each other
 ggplot(mpg, aes(x = displ, y = hwy)) + 
    geom_point() + 
    geom_point(
      data = mpg |> filter(class == "2seater"), 
      shape = "circle open",
      size = 3,
      color = "red"
    )


#Histogram plot to study the distribution of highway miles
ggplot(mpg, aes(x = hwy)) +
  geom_histogram(
    binwidth = 2,
    color = "red",
    fill = "skyblue"
  )


#Density plot to study the distribution of highway miles
ggplot(mpg, aes(x = hwy)) +
  geom_density()

#Box plot to study the distribution of highway miles 
ggplot(mpg, aes(x = hwy)) +
  geom_boxplot(
    fill = "lightgreen",
    color = "black",
    outlier.size = 3,
    outlier.color = "red"
  )

#Note:
#geom_boxplot works with a single x axis because it treats that as a category and plots the distribution on the y axis
#geom_jitter needs both x & y axis so that the jitter points know where to go exactly

#common trick is to add a constant y so that all points align horizontally
ggplot(mpg, aes(x = hwy)) +
  geom_boxplot(
    fill = "lightgreen",
    color = "black",
    outlier.size = 3,
    outlier.color = "red"
  ) +
  geom_jitter(
    aes(y = 1),
    color = "orange",
    alpha = 0.5
  )

#alternative is to flip the axes
ggplot(mpg, aes(x = "", y = hwy)) +
  geom_boxplot(
    fill = "lightgreen",
    color = "black",
    outlier.size = 3,
    outlier.color = "red"
  ) +
  geom_jitter(
    width = 0.3,
    color = "orange",
    alpha = 0.5
  )

#Exercise

#1)
#scatter plot to study the relationship between engine size(displ) and mileage(hwy)
#plot a smooth line over the scatter plot
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(
    size = 3
  ) +
  geom_smooth(
    method = "auto",
    color = "blue",
#    linewidth = 1,
    se = FALSE
  )


#2)
#scatter plot to study the relationship between engine size(displ) and mileage(hwy)
#plot a smooth line over the scatter plot for each level of drv
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(
    size = 3
  ) +
  geom_smooth(
    aes(group = drv),
    method = "auto",
    color = "blue",
    se = FALSE
  )

#3)
#scatter plot to study the relationship between engine size(displ) and mileage(hwy)
#plot separate colors for points for each level of drv
#plot separate smooth lines over the scatter plot for each level of drv
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point(
    size = 3
  ) +
  geom_smooth(
    method = "auto",
    se = FALSE
  )

#4)
#scatter plot to study the relationship between engine size(displ) and mileage(hwy)
#plot separate color points for each level of drv
#plot a single smooth line over the scatter plot

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(
    aes(color = drv),
    size = 3
  ) +
  geom_smooth(
    method = "auto",
    se = FALSE
  )

#4)
#scatter plot to study the relationship between engine size(displ) and mileage(hwy)
#plot separate colors for points for each level of drv
#plot separate smooth lines of different type over the scatter plot for each level of drv
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(
    aes(color = drv),
    size = 3
  ) +
  geom_smooth(
    aes(linetype = drv),
    method = "auto",
    se = FALSE,
  )