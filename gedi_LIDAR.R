# hdf for GEDI
rm(list=ls())
#if (!requireNamespace("BiocManager", quietly = TRUE))
 # install.packages("BiocManager")

#BiocManager::install("rhdf5")

library(rhdf5)
library(tidyverse)
library(raster)
library(forestr)
library(lattice)

setwd("/home/satish/Documents/ecodb/")

base_file <- shapefile("World_Countries/World_Countries.shp")
fname <- "/home/satish/Documents/ecodb/GEDI02_B_2019108110900_O01966_T02493_02_001_01.h5"

h5ls(fname)

height_bin0 <- h5read(fname, "/BEAM0000/geolocation/height_bin0")
height_lastbin <- h5read(fname, "/BEAM0000/geolocation/height_lastbin")

#dem <- h5read(fname, "/BEAM0000/geolocation/digital_elevation_model")

long <- h5read(fname, "/BEAM0000/geolocation/longitude_bin0")
lat <- h5read(fname, "/BEAM0000/geolocation/latitude_bin0")

pavd <- h5read(fname, "/BEAM0000/pavd_z")


summary(pavd_df)

image(pavd_mat)

mydf <- data.frame(long,lat,height_bin0,height_lastbin)

mydf <- filter(mydf, long >= 72.0)
mydf <- filter(mydf, lat >= 18.0)

dim(mydf)
View(mydf)

plot(mydf$long, mydf$lat, xlab = "Longitude", ylab = "Latitude")
plot(base_file, add=TRUE)

ggplot(data=mydf,aes(x=long,y=lat))+
           geom_point(data= mydf, aes(colour=factor(mydata)))


pavd_mat <- matrix(pavd, nrow=306734, ncol = 30)
pavd_df <- data.frame(pavd_mat)
pavd_df$long <- long 
pavd_df$lat <- lat

pavd_df <- filter(pavd_df, long >= 72.0)
pavd_df <- filter(pavd_df, lat >= 18.0)

head(pavd_df)

dz <- h5read(fname,"/BEAM0001/ancillary/dz")

write_csv(pavd_df, "pavd_lat_long.csv")



           
