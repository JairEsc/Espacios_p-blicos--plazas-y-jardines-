parques_polygon=sf::read_sf("Datos/Espacios Publicos/Parques_Jardines_Poligonos.shp")
parques_jardines=sf::read_sf("Datos/Espacios Publicos/Plazas_Parques_Jardines.shp")


source("../../ASUS Gamer Jair/codigos/puras_librerias.R")
greenLeafIcon <- makeIcon(
  iconUrl = "https://leafletjs.com/examples/custom-icons/leaf-green.png",
  iconWidth = 7, iconHeight = 14,
  iconAnchorX = 2, iconAnchorY = 9,
  shadowUrl = "https://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 5, shadowHeight = 6,
  shadowAnchorX = 4, shadowAnchorY = 6
)

mapa_web=leaflet() |> 
  addTiles(options = leaflet::tileOptions(opacity =0.6))|>
  addPolygons(data=parques_polygon |> st_zm() |> st_transform(st_crs("EPSG:4326")),fillColor = "#297008",opacity = 0.1,color = "#297008",weight = 1,fillOpacity = 0.9) |> 
  addMarkers(data=parques_jardines |> st_transform(st_crs("EPSG:4326")),icon =greenLeafIcon,group = "puntos"  )

mapa_web
saveWidget(mapa_web,file = "Entregables/Mapa web/espacios_publicos.html",title = "Plazas y Jardines")

