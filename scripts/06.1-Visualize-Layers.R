library(tidyverse)

#(I) Aesthetic mappings

# relationship between displacement and highway miles for various classes of cars

# relationship between 2 numeric variables (eng size in litres and miles) -> use scatterplot
# use facet/shape/size/color to encode class
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  geom_smooth(method = "auto", se = FALSE)


#Group
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(group = drv))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv))

#highlight 2 seater class in a scatter plot
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_point(
    data = mpg |> filter(class == "2seater"), 
    color = "red"
  ) +
  geom_point(
    data = mpg |> filter(class == "2seater"), 
    shape = "circle open", 
    size = 3, 
    color = "red"
  )







