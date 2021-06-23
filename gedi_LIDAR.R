# HDF for GEDI
# Code is based on rhdf5 package.
rm(list=ls())
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("rhdf5")

library(rhdf5)
library(tidyverse)
library(raster)
library(forestr)
library(lattice)

setwd("/home/user/GEDI/")

# Raster package is used only for shapefile.
# Any function for vector data can be used.
base_file <- shapefile("World_Countries/World_Countries.shp")
fname <- "/home/user/GEDI/GEDI02_B_2019108110900_O01966_T02493_02_001_01.h5"

# HDF file matadeta is stored.
h5_info <- h5ls(fname)
# Can be written to csv file.
write_csv(h5_info, "GEDI_B_layers_info.csv", col_names = TRUE)

# height_bin0 is first bins (topmost) in the pgap_theta_z relative to ground 
height_bin0 <- h5read(fname, "/BEAM0000/geolocation/height_bin0")
#Height of the last bin of the pgap_theta_z, relative to the ground
height_lastbin <- h5read(fname, "/BEAM0000/geolocation/height_lastbin")

#Digital elevation model height above the WGS84 ellipsoid
dem <- h5read(fname, "/BEAM0000/geolocation/digital_elevation_model")

# Longitude of first bin of the pgap_theta_z(height_bin0)
long <- h5read(fname, "/BEAM0000/geolocation/longitude_bin0")
# Longitude of first bin of the pgap_theta_z(latitude_bin0)
lat <- h5read(fname, "/BEAM0000/geolocation/latitude_bin0")

# Plant Area Volume Density profile
pavd <- h5read(fname, "/BEAM0000/pavd_z")

summary(pavd_df)
image(pavd_mat)

mydf <- data.frame(long,lat,height_bin0,height_lastbin)
# filter data based on longitidue and latitude of your region.
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



           
