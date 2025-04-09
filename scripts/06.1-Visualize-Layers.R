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

#(II) Facets

#Faceting splits a plot into subplots that each display one subset of the data based on a categorical variable

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() +
  facet_wrap(~cyl) +
  labs(
    title = "Scatter plot displ vs hwy miles", 
    subtitle = "facet by cyl"
  )

#facet_grid(rows ~ columns)
#facet_grid(x ~ .) = facet in rows
#facet_grid(. ~ y) = facet in columns
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(
    size = 1
  ) +
  facet_grid(drv ~ cyl) +
  labs(
    title = "Scatter plot displ vs hwy miles",
    subtitle = "facet by drive engine and cyl"
  )

#To visualize the relationship within each facet better, set the scales argument to free
#"free_x" will allow for different scales of x-axis across columns
#"free_y" will allow for different scales on y-axis across rows
#"free" will allow both
#Controls whether axes are fixed or free (e.g., "fixed", "free", "free_x", "free_y")
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_grid(
    drv ~ cyl,
    scales = "free"
  ) +
  labs(
    title = "Scatter plot displ vs hwy miles",
    subtitle = "facet by drive engine and cyl nos"
  )

#nrow controls how the facet panels are laid out. nrow=2 forces ggplot to plot the facets in 2 horizontal rows.
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_wrap(~drv, nrow = 2)

#For small to medium datasets: Color works well; faceting may feel unnecessary
# For larger datasets:
#   1.Faceting becomes more valuable because it breaks down complexity.
#   2.Color can get overwhelmed due to overplotting — you might miss patterns.
#   3.Combining both is often a good idea: facet by one variable, color by another (if distinct and small in number).


#(III) Statistical Transformations

#Many graphs, like scatterplots, plot the raw values of your dataset. 

#Other graphs, like bar charts, calculate new values to plot:
#1. Bar charts, histograms, and frequency polygons bin your data and then plot bin counts, the number of points that fall in each bin
#2. Smoothers fit a model to your data and then plot predictions from the model
#3. Boxplots compute the five-number summary of the distribution and then display that summary as a specially formatted box

#The algorithm used to calculate new values for a graph is called a stat, short for statistical transformation.

#If you already have the count , use stat = identity to plot the count directly
diamonds |>
  count(cut) |>
  ggplot(aes(x = cut, y = n)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = n), vjust = -0.5, size = 3) 
  #geom_label(aes(label = n), vjust = -0.5, size = 3) #geom label will show a background box behind the text



