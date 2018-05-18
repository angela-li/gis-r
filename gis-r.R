## ----setup, include=FALSE------------------------------------------------
options(htmltools.dir.version = FALSE)

## ----eval=FALSE, tidy=FALSE----------------------------------------------
## library(tidyverse)
## library(sf)
## library(tmap)
## 
## sales <- read_csv("output/sales-tidy.csv")
## tracts <- st_read("data/orig/shapefiles/detroit_tracts.shp")
## tracts <- rename(tracts, tract = GEOID)
## 
## sales <- sales %>%
##   right_join(tracts, ., by = "tract")
## 
## med_sales_map <- tm_shape(sales, unit = "mi") +
##   tm_fill("med_price", palette = "Blues", breaks = quantile(a$med_price), title = "Median Sales Price") +
##   tm_facets("after_hhf") +
##   tm_shape(tracts) +
##   tm_borders() +
##   tm_compass(fontsize = 0.6, color.dark = "dark grey") +
##   tm_scale_bar(color.dark = "dark grey")
## 
## save_tmap(med_sales_map, "doc/figs/med_sales_map.png")

## ----eval=FALSE, tidy=FALSE----------------------------------------------
## install.packages("sf")
## install.packages("tmap")

## ----warning=FALSE-------------------------------------------------------
# Load package
library(sf)

# Read in shapefile
chi <- st_read("data/Neighborhoods_2012b.shp")

## ------------------------------------------------------------------------
head(chi)

## ------------------------------------------------------------------------
class(chi)

## ------------------------------------------------------------------------
# Map it using base R: just shape outlines
plot(st_geometry(chi))

## ------------------------------------------------------------------------
# This maps all the attributes
plot(chi)

## ------------------------------------------------------------------------
chi2 <- st_read("data/ComArea_ACS14_f.shp")

## ------------------------------------------------------------------------
# Check what variables we have
names(chi2)

# Calculate population density
library(dplyr)
chi2 <- mutate(chi2, Pop2014 = Pop2014/shape_area)

## ------------------------------------------------------------------------
# Map population density by neighborhood
plot(chi2["Pop2014"])

## ----echo=FALSE----------------------------------------------------------
library(tmap)
tm_shape(chi2) +
  tm_fill("Pop2014", palette = "Purples", 
          title = "Population by Neighborhood, 2014")

## ----warning=FALSE-------------------------------------------------------
groceries <- st_read("data/groceries.shp")

## ----warning=FALSE-------------------------------------------------------
# Get the CRS (coordinate reference system) of the groceries point data
groceries_crs <- st_crs(groceries)

# Project the neighborhood boundaries
chi2 <- st_transform(chi2, groceries_crs)

## ----echo=FALSE----------------------------------------------------------
# Plot both
tm_shape(chi2) +
  tm_borders() + 
  tm_fill("Pop2014", palette = "Purples", 
          title = "Population by Neighborhood, 2014") +
  tm_shape(groceries) +
  tm_dots(title = "Groceries", size = 0.1, col = "black")

## ----message=FALSE-------------------------------------------------------
chi2 %>% 
  st_join(groceries, .) %>% 
  group_by(community) %>% 
  tally() %>%
  arrange(desc(n))

## ----eval=FALSE----------------------------------------------------------
## get_point_counts_in_buffer <- function(points_to_buffer,
##                                        points_to_intersect,
##                                        buffer_size = 500) {
##   number_points_within_buffer <- points_to_buffer %>%
##     st_buffer(buffer_size) %>%
##     st_contains(points_to_intersect) %>%
##     map_dbl(length) %>%
##     tibble(pts_in_buffer = .)
## 
##   return(number_points_within_buffer)
## }

