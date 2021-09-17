library(leaflet)
library(tidyverse)
dir <- "C:/Users/52552/Alexito/ejemplos_R/ubicaciones_conalep"
setwd(dir)
data <- read.csv("./GeoReferenciaPlanteles.csv")

data <- data %>% filter(!data$latitud%in%"(null)" & !data$latitud%in%0) %>% 
         mutate(Latitud = as.numeric(latitud),
                Longitud= as.numeric(longitud))

Latitud <- as.numeric(data$latitud)
Longitud<- as.numeric(data$longitud)

data$popup <- paste("<b>Plantel #: </b>", data$clave_plantel ,"<br>", "<b>CCT: </b>", data$cct,
                    "<br>", "<b>Description: </b>", data$plantel,
                    "<br>", "<b>Entidad: </b>", data$clave_entidad,
                    "<br>", "<b>Domicilio: </b>", data$domicilio_plantel,
                    "<br>", "<b>Longitud: </b>", data$longitud,
                    "<br>", "<b>Latitud: </b>", data$latitud)

leaflet(data) %>% addTiles() %>%
  addTiles(group = "OSM (default)") %>%
  addProviderTiles(provider = "Esri.WorldStreetMap", group = "World StreetMap") %>%
  addProviderTiles(provider = "Esri.WorldImagery", group = "World Imagery") %>%
  # addProviderTiles(provider = "NASAGIBS.ViirsEarthAtNight2012",group = "Nighttime Imagery") %>%
  addMarkers(lng = Longitud[1:120], 
             lat = Latitud[ 1:120], 
             popup = data$popup, 
             clusterOptions = markerClusterOptions()) %>%
  addLayersControl(
    baseGroups = c("OSM (default)","World StreetMap", "World Imagery"),
    options = layersControlOptions(collapsed = T)
  )


