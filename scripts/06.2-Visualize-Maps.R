library(tidyverse)
library(ozmaps)
library(sf)
library(rmapshaper)


#(I) Polygon Maps
counties <- map_data("county", "michigan") |>
  select(long, lat, group, subregion)

ggplot(counties, aes(x = long, y = lat)) +
  geom_point(
    size = 0.5,
    show.legend = FALSE
  ) +
  coord_quickmap() #This is a coordinate system in ggplot2 that sets the aspect ratio correctly for maps
                   #one unit in the x direction is the same length as one unit in the y direction
                   #Ensures that the shapes don’t get distorted when plotting geographic maps


ggplot(counties, aes(x = long, y = lat, group = group)) + #group ensures the right boundaries are connected
  geom_polygon(
    fill = "lightblue",
    color = "white"
  ) +
  coord_quickmap()


#(II) Simple Features Maps

#“longitude-latitude” data format is not typically used in real world mapping
#Vector data for maps are typically encoded using the “simple features” standard produced by the Open Geospatial Consortium
#The sf package developed by Edzer Pebesma provides an excellent toolset for working with such data
#geom_sf() and coord_sf() functions in ggplot2 are designed to work together with the sf package


ggplot(ozmap_states) +
  geom_sf() +
  coord_sf()

#geom_sf relies on a geometry aesthetic that is not used elsewhere in ggplot2
#This geometry aesthetic can be specified in one of three ways:
#1) When nothing is specified, geom_sf() will attempt to map it a column named geometry in the sf object
#2) If the data argument is an sf object, geom_sf() can automatically detect a geometry column even if it is not called geometry
#3) You can specify the mapping manually with aes(geometry = column1). Useful when you have multiple geometry columns

oz_states <- ozmap_states |>
  filter(NAME != "Other Territories")

oz_votes <- rmapshaper::ms_simplify(ozmaps::abs_ced)
#A function from the rmapshaper package that simplifies spatial geometries, reducing the number of vertices while maintaining the general shape. 
#Useful for plotting large maps efficiently.

ggplot() +
  geom_sf(
    data = oz_states,
    aes(fill = NAME),
    show.legend = FALSE
  ) +
  geom_sf(
    data = oz_votes,
    fill = NA
  ) +
  coord_sf()







