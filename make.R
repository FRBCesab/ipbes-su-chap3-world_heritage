#' IPBES Sustainable Use Assessment - Figure Chapter 3 - World Heritage List
#' 
#' This R script reproduces the Figure 'World Heritage List' of the 
#' chapter 3 of the IPBES Sustainable Use Assessment. This figure shows the 
#' global distribution of UNESCO World Heritage sites (both cultural and 
#' natural) with an emphasis on their endangered status.
#' 
#' @author Nicolas Casajus <nicolas.casajus@fondationbiodiversite.fr>
#' @date 2022/04/15



## Install `remotes` package ----

if (!("remotes" %in% installed.packages())) install.packages("remotes")


## Install required packages (listed in DESCRIPTION) ----

remotes::install_deps(upgrade = "never")


## Load project dependencies ----

devtools::load_all(here::here())


## Read IPBES Countries ----

world <- sf::st_read(here::here("data", "ipbes-regions", "ipbes_subregions_2",
                                "IPBES_Regions_Subregions2.shp"))
wgs84 <- sf::st_crs(world)

dotted <- sf::st_read(here::here("data", "ipbes-regions", "dotted_borders",
                                 "dotted_borders.shp"))

dashed <- sf::st_read(here::here("data", "ipbes-regions", "dashed_borders",
                                 "dashed_borders.shp"))

lakes <- sf::st_read(here::here("data", "ipbes-regions", "major_lakes",
                                "Major_Lakes.shp"))

grey_areas <- sf::st_read(here::here("data", "ipbes-regions", "grey_areas",
                                     "grey_areas.shp"))


## Project in Robinson ----

robin <-  "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"

world      <- sf::st_transform(world, robin)
dotted     <- sf::st_transform(dotted, robin)
dashed     <- sf::st_transform(dashed, robin)
lakes      <- sf::st_transform(lakes, robin)
grey_areas <- sf::st_transform(grey_areas, robin)


# Create Graticules ----

lat <- c( -90,  -60, -30, 0, 30,  60,  90)
lon <- c(-180, -120, -60, 0, 60, 120, 180)

grat <- graticule::graticule(lons = lon, lats = lat, proj = robin, 
                             xlim = range(lon), ylim = range(lat))


## Data to map ----
## ... a data frame with two columns: 'Country' and 'N of studies'
## ... (in this example)

tab <- readxl::read_xls(here::here("data", "whc-sites-2021.xls"), sheet = 1)
tab <- as.data.frame(tab)


## Subset data ----

tab <- tab[ , c("longitude", "latitude", "danger", "category")]


## Convert to sf ----

tab <- sf::st_as_sf(tab, coords = 1:2)
tab <- sf::st_set_crs(tab, wgs84)
tab <- sf::st_transform(tab, robin)


## Define Colors ----

borders  <- "#c8c8c8"
texte    <- "#666666"
col_sea  <- "#e5f1f6"
col_grat <- "#bfdde9"


## Define symbols ----

tab$"symbol" <- ifelse(tab$"category" == "Cultural", 22, 
                       ifelse(tab$"category" == "Natural", 21, 23))

tab$"color"  <- ifelse(tab$"category" == "Cultural", "#FFBA2B", 
                       ifelse(tab$"category" == "Natural", "#00AD1D", "#3F81ED"))

tab$"color"  <- ifelse(tab$"danger" == 1, "#FF001F", tab$"color")


tab <- tab[with(tab, order(danger, category)), ]


## Graphical Device ----

# png(here::here("figures", "ipbes-su-chap3-world_heritage.png"),
#     width = 12, height = 7.5, units = "in", res = 600, pointsize  = 18)

# svg(here::here("figures", "ipbes-su-chap3-world_heritage.svg"),
#     width = 12, height = 7.5, pointsize  = 18)

pdf(here::here("figures", "ipbes-su-chap3-world_heritage.pdf"),
    width = 12, height = 7.5, pointsize  = 18, version = 1.4)


## Basemap + Data + Graticules ----

par(mar = c(2, 1, 0, 1), family = "serif")

sp::plot(grat, lty = 1, lwd = 0.2, col = borders)

plot(sf::st_geometry(world), col = "#f0f0f0", border = borders,
     lwd = 0.2, add = TRUE)

plot(sf::st_geometry(dotted), add = TRUE, col = "white", lwd = 0.2, 
     lty = "solid")
plot(sf::st_geometry(dotted), add = TRUE, col = borders, lwd = 0.2, 
     lty = "dotted")

plot(sf::st_geometry(dashed), add = TRUE, col = "white", lwd = 0.2, 
     lty = "solid")
plot(sf::st_geometry(dashed), add = TRUE, col = borders, lwd = 0.2, 
     lty = "dashed")

plot(sf::st_geometry(grey_areas), add = TRUE, col = "#a8a8a8", border = borders,
     lwd = 0.2)


## Legend ----

text(x = -17000000, y = -10550000, col = texte, font = 1, pos = 4,
     labels = "Category of site:", xpd = TRUE, cex = 0.75)

points(x = -11500000, y = -10500000, bg = "#FFBA2B", col = "white", pch = 22, 
       cex = 1.25, xpd = TRUE)
text(x = -11500000, y = -10550000, col = texte, font = 1, pos = 4,
     labels = "Cultural site", xpd = TRUE, cex = 0.75)

points(x = -11500000, y = -11250000, bg = "#00AD1D", col = "white", pch = 21, 
       cex = 1.25, xpd = TRUE)
text(x = -11500000, y = -11300000, col = texte, font = 1, pos = 4,
     labels = "Natural site", xpd = TRUE, cex = 0.75)

points(x = -11500000, y = -12000000, bg = "#3F81ED", col = "white", pch = 23, 
       cex = 1.25, xpd = TRUE)
text(x = -11500000, y = -12050000, col = texte, font = 1, pos = 4,
     labels = "Mixed site", xpd = TRUE, cex = 0.75)


text(x =  -5000000, y = -10550000, col = texte, font = 1, pos = 4,
     labels = "Sites in danger:", xpd = TRUE, cex = 0.75)

points(x = 500000, y = -10500000, bg = "#FF001F", col = "white", pch = 22, 
       cex = 1.25, xpd = TRUE)
text(x = 500000, y = -10550000, col = texte, font = 1, pos = 4,
     labels = "Cultural site", xpd = TRUE, cex = 0.75)

points(x = 500000, y = -11250000, bg = "#FF001F", col = "white", pch = 21, 
       cex = 1.25, xpd = TRUE)
text(x = 500000, y = -11300000, col = texte, font = 1, pos = 4,
     labels = "Natural site", xpd = TRUE, cex = 0.75)

points(x = 500000, y = -12000000, bg = "#FF001F", col = "white", pch = 23, 
       cex = 1.25, xpd = TRUE)
text(x = 500000, y =   -12050000, col = texte, font = 1, pos = 4,
     labels = "Mixed site", xpd = TRUE, cex = 0.75)

text(x = -17000000, y = -9250000, col = texte, font = 2, pos = 4,
     labels = "UNESCO World Heritage List")


## Add lakes ----

plot(sf::st_geometry(lakes), add = TRUE, col = col_sea, border = col_grat,
     lwd = 0.2)


## Add data ----

for (i in 1:nrow(tab))
  plot(sf::st_geometry(tab[i, ]), add = TRUE, col = "white",
       bg = tab$"color"[i], pch = tab$"symbol"[i], cex = 0.85)


par(xpd = FALSE)

dev.off()
