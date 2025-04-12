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


#after_stat() is used inside aes() to refer to a computed variable after a statistical transformation has been applied
#geom_bar() : stat=count :  count / prop
#geom_histogram : stat=bin : count / density / ncount / ndensity
#geom_smooth : stat=smooth : y, ymin, ymax
#geom_boxplot : stat=boxplot : ymin / lower / middle / upper / ymax / outliers


ggplot(diamonds) +
  geom_bar(aes(x = cut, y = after_stat(prop), group = 1))
#geom_bar groups the data. By using group = 1 we are forcing ggplot to treat all rows as 1 group to calculate the proportions


#(III.1) stat_summary()

#stat_summary() lets us summarize the data before plotting - instead of plotting the raw data points
ggplot(diamonds) +
  stat_summary(
    aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )


#plot mean highway miles for each class as a point
ggplot(mpg, aes(x = class, y = hwy)) +
  stat_summary(
    fun = mean,
    geom = "point",  #show the points in layer 1
    color = "blue",
    size = 3
  ) + 
  stat_summary(
    fun = mean,
    geom = "text",   #show the values in layer 2
    aes(label = round(after_stat(y),2)),
    vjust = -0.6,
    color = "black"
  )

#show the mean of highway miles for each class with error bars showing +-1 SD
ggplot(mpg, aes(x = class, y = hwy)) +
  stat_summary(
    fun = mean,
    geom = "point", #Layer 1 will plot the mean point
    color = "blue",
    size = 3
  ) +
  stat_summary(
    fun = "mean",
    geom = "text", #Layer 2 will show the mean value for the point
    aes(label = round(after_stat(y),2)),
    color = "black",
    hjust = 1.3
  ) +
  stat_summary(
    fun.data = mean_sdl, 
    fun.args = list(mult = 1),
    geom = "errorbar", #Layer 3 will show the errorbar with +-1 SD
    width = 0.2
  ) +
  stat_summary(
    inherit.aes = FALSE,
    mapping = aes(x = class, y = hwy, label = round(after_stat(ymin),2)),
    fun.data = mean_sdl,
    fun.args = list(mult = 1),
    geom = "text",   #Layer 4 will show the minimum value in red
    color = "red",
    vjust = -1.5 
  ) +
  stat_summary(
    inherit.aes = FALSE,
    mapping = aes(x = class, y = hwy, label = round(after_stat(ymax),2)),
    fun.data = mean_sdl,
    fun.args = list(mult = 1),
    geom = "text",  #Layer 5 will show the maximum value in green
    color = "darkgreen",
    vjust = 2
  )


#(IV) Position Adjustments

#plot by drv engine
ggplot(mpg, aes(x = drv)) +
  geom_bar(aes(color = drv)) +
  geom_text(
    stat = "count",
    aes(label = after_stat(count)),
    vjust = -0.5
  )

#plot by drv engine
ggplot(mpg, aes(x = drv)) +
  geom_bar(
    aes(fill = drv)
  ) +
  geom_text(
    stat = "count",
    aes(label = after_stat(count)),
    vjust = -0.5
  )

#plot by drv engine and different class
ggplot(mpg, aes(x = drv)) +
  geom_bar(
    aes(fill = class)
  )

#Interesting : Show count for each stack
ggplot(mpg, aes(x = drv)) +
  geom_bar(aes(fill = class)) + #Layer1 will the bar chart
                                #fill = class will stack the bars
  
  #stat=count will make ggplot automatically compute the row count for each combination of aesthetics drv & class
  geom_text(
    stat = "count",
    aes(
      fill = class, 
      label = after_stat(count)
    ),
    position = position_stack(vjust = 0.5),
    color = "white"
  )

#In ggplot2, position adjustments control how elements are arranged when they would otherwise overlap
#Especially important in bar charts where multiple bars can be mapped to the same x-position

#(IV.1) position = "identity"
#Bars overlap directly
#Bars stacked on top of each other, unless alpha is used to differentiate them
ggplot(mpg, aes(x = drv)) +
  geom_bar(
    aes(fill = class),
    position = "identity",
    alpha = 0.5
  ) 

#(IV.2) position = "dodge"
#Bars are placed next to each other within each x group
ggplot(mpg, aes(x = drv)) +
  geom_bar(
    aes(fill = class),
    #position = "dodge"
    position = position_dodge(width = 0.9)
  ) +
  geom_text(
    stat = "count",
    aes(fill = class, label = after_stat(count)),
    position = position_dodge(width = 0.9),
    color = "black",
    vjust = -0.2
  )

#(IV.3) position = "fill"
#Bars are stacked and scaled to the same height
ggplot(mpg, aes(x = drv)) +
  geom_bar(
    aes(fill = class),
    position = "fill"
  )
