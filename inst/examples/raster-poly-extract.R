require(raster)

# Create interger class raster
r <- raster(ncol=36, nrow=18)
r[] <- round(runif(ncell(r),1,10),digits=0)

# Create two polygons
cds1 <- rbind(c(-180,-20), c(-160,5), c(-60, 0), c(-160,-60), c(-180,-20))
cds2 <- rbind(c(80,0), c(100,60), c(120,0), c(120,-55), c(80,0))
polys <- SpatialPolygonsDataFrame(SpatialPolygons(list(Polygons(list(Polygon(cds1)), 1), 
                                                       Polygons(list(Polygon(cds2)), 2))),data.frame(ID=c(1,2)))

# Extract raster values to polygons                             
( v <- extract(r, polys) )

# Get class counts for each polygon
v.counts <- lapply(v,table)

# Calculate class percentages for each polygon
( v.pct <- lapply(v.counts, FUN=function(x){ x / sum(x) } ) )

# Create a data.frame where missing classes are NA
class.df <- as.data.frame(t(sapply(v.pct,'[',1:length(unique(r)))))  

# Replace NA's with 0 and add names
class.df[is.na(class.df)] <- 0   
names(class.df) <- paste("class", names(class.df),sep="")

# Add back to polygon data
polys@data <- data.frame(polys@data, class.df)
head(polys@data)
# ID     class1    class2    class3    class4    class5    class6     class7    class8     class9
# 1  1 0.05263158 0.1315789 0.1052632 0.1052632 0.1315789 0.1052632 0.07894737 0.1578947 0.05263158
# 2  2 0.04000000 0.1600000 0.1600000 0.1600000 0.1600000 0.0800000 0.08000000 0.0800000 0.04000000
# class10
# 1 0.07894737
# 2 0.04000000
