library(leaflet)
library(tidyverse)

data <- read.csv("./GeoReferenciaPlanteles.csv")

data <- data %>% filter(!data$latitud%in%"(null)" & !data$latitud%in%0) %>% 
         mutate(Latitud = as.numeric(latitud),
                Longitud= as.numeric(longitud))



bla <- list()
mapa <-list()
cve_ent <- 1:32
for(i in cve_ent){
  bla[[i]] <- data[data$clave_entidad%in%cve_ent[i],]
  
  
  bla[[i]]$popup <- paste("<b>Plantel #: </b>", bla[[i]]$clave_plantel ,"<br>", "<b>CCT: </b>", bla[[i]]$cct,
                     "<br>", "<b>Description: </b>", bla[[i]]$plantel,
                     "<br>", "<b>Entidad: </b>", bla[[i]]$entidad,
                     "<br>", "<b>Domicilio: </b>", bla[[i]]$domicilio_plantel,
                     "<br>", "<b>Longitud: </b>", bla[[i]]$longitud,
                     "<br>", "<b>Latitud: </b>", bla[[i]]$latitud)
  Latitud <- as.numeric(bla[[i]]$latitud)
  Longitud<- as.numeric(bla[[i]]$longitud)
  
 mapa[[i]]<- bla[[i]] %>% leaflet() %>% addTiles() %>%
    addTiles(group = "OSM (default)") %>%
    addProviderTiles(provider = "Esri.WorldStreetMap", group = "World StreetMap") %>%
    addProviderTiles(provider = "Esri.WorldImagery", group = "World Imagery") %>%
    #addProviderTiles(provider = "NASAGIBS.ViirsEarthAtNight2012",group = "Nighttime Imagery") %>%
    addMarkers(lat = Latitud, 
               lng = Longitud, 
               popup = bla[[i]]$popup,
               clusterOptions = markerClusterOptions()) %>%
    addLayersControl(
      baseGroups = c("OSM (default)","World StreetMap", "World Imagery"),
      options = layersControlOptions(collapsed = T)
    ) 
  
}

#Para visualizar los planteles por cada entidad se despliega cada uno de los mapas-
View(mapa[[1]])



