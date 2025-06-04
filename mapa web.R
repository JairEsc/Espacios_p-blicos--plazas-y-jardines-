parques_polygon=sf::read_sf("Datos/Espacios Publicos/Parques_Jardines_Poligonos.shp")
parques_jardines=sf::read_sf("Datos/Espacios Publicos/Plazas_Parques_Jardines.shp")


source("../../ASUS Gamer Jair/codigos/puras_librerias.R")

municipios=sf::read_sf("../../Reutilizables/Cartografia/municipiosjair.shp")
greenLeafIcon <- makeIcon(
  iconUrl = "https://leafletjs.com/examples/custom-icons/leaf-green.png",
  iconWidth = 12, iconHeight = 25,
  iconAnchorX = 2, iconAnchorY = 9,
  shadowUrl = "https://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 5, shadowHeight = 6,
  shadowAnchorX = 4, shadowAnchorY = 6
)
mapa_web=leaflet() |> 
  addTiles(options = leaflet::tileOptions(opacity =0.8))|>
  addPolygons(data=municipios |> as("Spatial"),
              label = municipios$NOM_MUN,fillColor = "gray",fillOpacity = 0.1,color = "white",opacity = 1,weight = 5,group = "Municipios") |> 
  addPolygons(data=parques_polygon |> st_zm() |> st_transform(st_crs("EPSG:4326")),fillColor = "#297008",opacity = 0.1,color = "#297008",weight = 1,fillOpacity = 0.9,
              popup = parques_polygon$Name) |> 
  addMarkers(data=parques_jardines |> st_transform(st_crs("EPSG:4326")),icon =greenLeafIcon,group = "puntos" ,
             popup = paste0(parques_jardines$DESCRIPCIO,ifelse(parques_jardines$NOMBRE%in%c('NO APLICA',"S/espec","NINGUNO"),"",paste0("-",parques_jardines$NOMBRE) ) )) |> 
  #addLegend(title = "Porcentaje de Pobreza",,position = "bottomright",pal = colorear_rojos_factor,values =c("[0-20)", "[20,40)", "[40,60)", "[60,80)", "[80-100]"), opacity = 1) |> 
  addSearchFeatures(targetGroups = "Municipios",
                    options = searchFeaturesOptions(
                      zoom = 12, 
                      openPopup = F,
                      firstTipSubmit =F,initial = F,
                      hideMarkerOnCollapse =T))|>setView(lng = -98.7591, lat = 20.0511, zoom = 9) |> 
  addEasyButton(
    easyButton(
      icon = "fa-info-circle",
      title = "Información",
      onClick = JS("function(btn, map){ 
        var modal = document.getElementById('infoModal');
        if (modal) modal.style.display = 'block';
      }")
    )
  )|> 
  prependContent(
    tags$div(
      id = "infoModal",
      class = "modal",
      style = "display:none; position:fixed; top:20%; left:20%; width:60%; background:white; padding:20px; border:2px solid black; z-index:1000;",
      tags$h3("Información del Mapa"),
      tags$p(
        "La Dirección de Análisis Geográfico y Mejora a las Políticas Públicas a través del Sistema de Información Georreferenciada del Estado de Hidalgo (",
        tags$a(href = "http://sigeh.hidalgo.gob.mx/", "SIGEH"), # Link added here
        ") georreferenció la ubicación a nivel de punto o polígono las principales plazas y jardines en el estado"
      ),
      tags$button("Cerrar", onclick = "document.getElementById('infoModal').style.display='none'")
    )
  ) |> addLogo(img = "https://raw.githubusercontent.com/JairEsc/Gob/main/Otros_archivos/imagenes/Planeacion_sigeh.png",src = "remote",url = "http://sigeh.hidalgo.gob.mx/",width = "400px",height='71px',position = "bottomleft") |> 
  addLegendImage(images = c("https://leafletjs.com/examples/custom-icons/leaf-green.png","Entregables/Mapa web/cuadro_verde.png"), 
  labels = c("Espacios públicos a nivel de punto","Espacios públicos a nivel de polígono"),title = "Simbología",position='bottomright',)
mapa_web


saveWidget(mapa_web,file = "Entregables/Mapa web/espacios_publicos.html",title = "Plazas y Jardines")
##Logo direccion general ... 
#https://raw.githubusercontent.com/JairEsc/Gob/main/Otros_archivos/imagenes/sigeh_solo_.png
#Logo de planeacion
#https://raw.githubusercontent.com/JairEsc/Gob/main/Otros_archivos/imagenes/Logotipo%20armas%20v11.png

