library(shiny)
library(leaflet)
library(RColorBrewer)
library(ggplot2)
library(tidyverse)
library(viridis)

load(file = "WWW/C02NorthernHemisphere.Rdata")
load(file = "WWW/C02Worldwide.Rdata")
load(file = "WWW/CanadianPrecip.Rdata")
load(file = "WWW/CanadianAvgSnow.Rdata")
load(file = "WWW/CanadianMaxTemp.Rdata")
load(file = "WWW/CanadianMeanTemp.Rdata")
load(file = "WWW/CanadianMinTemp.Rdata")
station <- read.csv(file = "WWW/Temperature_Stations.csv")

nMax = merge(MaxTemp, station, by.x = "InfoTemp[1]", by.y = "stnid", sort = TRUE)
nMean = merge(MeanTemp, station, by.x = "InfoTemp[1]", by.y = "stnid", sort = TRUE)
nMin = merge(MinTemp, station, by.x = "InfoTemp[1]", by.y = "stnid", sort = TRUE)

shinyServer(function(input, output) {
  
  options(shiny.sanitize.errors = FALSE)
  
  output$latitle <- renderText({
    if (input$range == "Northern Hemisphere"){
      paste("CO2 at surface level ", input$latitude, "th parallel North")
    }else{
      "CO2 at surface levels Worldwide"
    }
      
  })
  
  output$detitle <- renderText({
    paste("Density of Snow vs. Precipitation in",  month.abb[input$month], ",", input$year, "at", input$Province, sep = " ")
  })
  
  output$co2plot <- renderPlot({
    
    
    color <- switch(input$range, 
                    "Northern Hemisphere" = "darkblue",
                    "Worldwide" = "darkorange")
    
    datay <- switch(input$range, 
                    "Northern Hemisphere" = Co2North$YearDecimal,
                    "Worldwide" = Co2World$YearDecimal)
    
    if (input$latitude == "30") datax <- Co2North$Latitude30value
    if (input$latitude == "33") datax <- Co2North$Latitude33value
    if (input$latitude == "37") datax <- Co2North$Latitude37value
    if (input$latitude == "41") datax <- Co2North$Latitude41value
    if (input$latitude == "44") datax <- Co2North$Latitude44value
    if (input$latitude == "49") datax <- Co2North$Latitude49value
    if (input$latitude == "53") datax <- Co2North$Latitude53value
    if (input$latitude == "58") datax <- Co2North$Latitude58value
    if (input$latitude == "64") datax <- Co2North$Latitude64value
    if (input$latitude == "72") datax <- Co2North$Latitude72value
    if (input$latitude == "90") datax <- Co2North$Latitude90value
    if (input$range == "Worldwide") datax <- Co2World$Value
    
    plot(datay, datax, type="l", col = color, main=NA,
         xlab = "Year", ylab = "Carbon Dioxide Level (parts per million)")
  })
  
  output$density <- renderPlot({
    
    datasnow = subset(AllSnow, AllSnow[,input$month+1] != -9999.9 & AllSnow$`InfoTemp[3]` == input$Province & AllSnow$Year == input$year)
    dataprecip = subset(AllPrecip, AllPrecip[,input$month+1] != -9999.9 & AllPrecip$`InfoTemp[3]` == input$Province & AllPrecip$Year == input$year)
    
    datasnow = datasnow[c("InfoTemp[1]", month.abb[input$month])]
    names(datasnow)[names(datasnow) == month.abb[input$month]] = "Snowfall"
    dataprecip = dataprecip[c("InfoTemp[1]", month.abb[input$month])]
    names(dataprecip)[names(dataprecip) == month.abb[input$month]] = "Precipitation"
    snownprecip = merge(datasnow, dataprecip, by = "InfoTemp[1]")
    snownprecip = snownprecip %>% gather(key = "observation", value="value", -c(1))
    
    
    if (nrow(datasnow) < 2){
      title("Sorry, the snow data of you choosing is not available")
    }else if(nrow(dataprecip) < 2){
      title("Sorry, the precipitation data of you choosing is not available")
      
    }else{
      ggplot(snownprecip, aes(value, colour=observation, fill=observation)) + 
        theme(legend.title = element_blank(), legend.text=element_text(size=15)) +
        geom_density(alpha=0.5) + 
        coord_cartesian(ylim=c(0, 0.1))
      #dsnow = density(datasnow[,input$month+1])
      #dprecip = density(dataprecip[,input$month+1])
      #plot(dsnow, main=NA, col = "#2166AC", lwd = 3, lty = 1)
      #lines(dprecip, col = "#D6604D", lwd = 3, lty = 2)
      #legend("topright", c("Snowfall","Precipitation"), col = c("#2166AC", "#D6604D"), bty = "n", lty=1:2, cex = 1.2)
    }
  })

  output$circle <- renderPlot({
    datasnow = subset(AllSnow, AllSnow$Annual != -9999.9 & AllSnow$Year == input$year)
    names(datasnow)[names(datasnow) == "Annual"] = "SnowAnnual"
    names(datasnow)[names(datasnow) == "InfoTemp[2]"] = "location"
    names(datasnow)[names(datasnow) == "InfoTemp[3]"] = "Province"
    
    dataprecip = subset(AllPrecip, AllPrecip$Annual != -9999.9 & AllPrecip$Year == input$year)
    names(dataprecip)[names(dataprecip) == "Annual"] = "PrecipAnnual"
    names(dataprecip)[names(dataprecip) == "InfoTemp[2]"] = "location"
    names(dataprecip)[names(dataprecip) == "InfoTemp[3]"] = "Province"
    
    newdata = merge(datasnow, dataprecip ,by=c("location","Province", "Year"))
    newdata1 = aggregate(SnowAnnual ~ Province + Year, newdata, mean)
    newdata2 = aggregate(PrecipAnnual ~ Province + Year, newdata, mean)
    newdata = merge(newdata1, newdata2 ,by=c("Province", "Year"))
    newdata = newdata %>% gather(key = "observation", value="value", -c(1,2))
    num = nlevels(as.factor(newdata$observation))
    
    newdata = newdata %>% arrange(Province)
    newdata$id = rep(seq(1, nrow(newdata)/num) , each = num)
    
    empty_bar = 10
    (to_add = matrix(NA, empty_bar, ncol(newdata)))
    to_add[,1] = "BC"
    to_add[,5] = nrow(newdata)/2 +2
    colnames(to_add) = colnames(newdata)
    newdata=rbind(newdata, to_add)
    newdata$id = as.integer(newdata$id)
    newdata$value = as.integer(newdata$value)

    label_data= newdata %>% group_by(id, Province) %>% summarize(tot=sum(value))
    (number_of_bar=nrow(label_data))
    angle= 90 - 360 * (label_data$id- 0.5) /number_of_bar     
    label_data$hjust<-ifelse(angle < -90, 1, 0)
    label_data$angle<-ifelse(angle < -90, angle + 180, angle)

    ggplot(newdata) +      
      geom_bar(aes(x=as.factor(id), y=value, fill=observation), stat="identity", alpha=0.5) +
      scale_fill_viridis(discrete=TRUE, name=" ", labels=c("Precipitation", "Snowfall")) +
      annotate("text", x = rep(max(newdata$id),5), y = c(0, 500, 1000, 1500, 2000), label = c("0", "500", "1000", "1500", "2000") , color="grey", size=6 , angle= 0, hjust=1) +
      ylim(-600, max(label_data$tot, na.rm=T)) +
      theme_minimal() +
      theme(
        axis.text = element_blank(),
        axis.title = element_blank(),
        panel.grid = element_blank(),
        legend.text=element_text(size=15),
        plot.margin = margin(1, 1, 1, 2, "cm")
      ) +
      coord_polar(start = 0) +
      
      # Add labels on top of each bar
      geom_text(data = label_data, aes(x = id, y=tot, label = paste(" ",Province, " ", as.integer(tot), " "), hjust=hjust), 
                color = "#6f95ab",  alpha = 1, size = 4, angle = label_data$angle, inherit.aes = FALSE ) +
  
      geom_text(x = 0, y = -600, label = input$year, color = "#6f95ab", alpha = 1, size = 10) 
  }) 
  
  mapdata <- reactive({
    
    if (input$temp == "Max Temp") {
      data = subset(nMax, nMax[,input$month1+2] != -9999.9 & nMax$Year == input$year1)
      
    }else if (input$temp == "Mean Temp") {
      data = subset(nMean, nMean[,input$month1+2] != -9999.9 & nMean$Year == input$year1)
    } else {
      data = subset(nMin, nMin[,input$month1+2] != -9999.9 & nMin$Year == input$year1)
    }
    
    names(data)[names(data) == "InfoTemp[1]"] = "id"
    
    colorData <- ifelse(data[,input$month1+2] > 30, "above 30 degree",
                        ifelse(data[,input$month1+2] > 20, "20 to 30 degree",
                               ifelse(data[,input$month1+2] > 10, "10 to 20 degree",
                                      ifelse(data[,input$month1+2] > 0, "0 to 10 degree",
                                             ifelse(data[,input$month1+2] > -10, "-10 to 0 degree",
                                                    ifelse(data[,input$month1+2] > -20, "-20 to -10 degree",
                                                           ifelse(data[,input$month1+2] > -30, "-30 to -20 degree",
                                                                  "below -30 degree")))))))
    
    colorData <- factor(colorData, levels = c("above 30 degree", "20 to 30 degree", "10 to 20 degree", "0 to 10 degree", "-10 to 0 degree", "-20 to -10 degree","-30 to -20 degree", "below -30 degree"))
    
    pal <- colorFactor("Spectral", colorData, ordered = FALSE)
    
    radius <- (data[,input$month1+2] + 60) * 1500
    
    popup = paste(input$temp, br(), data[,input$month1+2], " degree", br(), data$`InfoTemp[2]`)
    
    mapdata = list(data = data, colorData = colorData, pal = pal, radius = radius, popup = popup)
    
  })
  
  output$tempmap = renderLeaflet({
    mapdata = mapdata()
    data = mapdata$data
    colorData = mapdata$colorData
    pal = mapdata$pal
    radius = mapdata$radius
    popup = mapdata$popup
    
    leaflet() %>%
      addTiles() %>%
      setView(lng = -115.25, lat = 55.25, zoom = 4) %>%
      clearShapes() %>%
      addCircles(data$long..deg.,data$lat..deg., radius= radius, stroke=FALSE,
                 fillOpacity = 0.6, fillColor = pal(colorData), popup = popup) %>%
      addLegend("bottomright", pal = pal, values = colorData, title = input$temp, layerId = "colorlegend")
    
  })
  
  observe({
    
    mapdata = mapdata()
    data = mapdata$data
    colorData = mapdata$colorData
    pal = mapdata$pal
    radius = mapdata$radius
    popup = mapdata$popup
    
    leafletProxy("tempmap") %>%
      clearShapes() %>%
      addCircles(data$long..deg.,data$lat..deg., radius= radius, stroke=FALSE,
                 fillOpacity = 0.6, fillColor = pal(colorData), popup = popup, layerId = data$id ) %>%
      addLegend("bottomright", pal = pal, values = colorData, title = input$temp, layerId = "colorlegend")
    
    
  })
  
  observe({
    if (input$temp == "Max Temp") {
      data = subset(nMax, nMax$Annual != -9999.9)
      
    }else if (input$temp == "Mean Temp") {
      data = subset(nMean, nMean$Annual != -9999.9)
      
    } else {
      data = subset(nMin, nMin$Annual != -9999.9)
      
    }
    
    leafletProxy("tempmap") %>% clearPopups()
    event <- input$tempmap_shape_click
    if (is.null(event)) output$avg <- renderText({"Please click a point to show the tempurature trending of a specific station: "})
    print(event) # Show values on console fort testing
    
    newdata = data[c(data$long..deg. == event$lng, data$lat..deg. == event$lat), ]
    output$avgtemp <- renderPlot({ggplot(newdata, aes(x = Year, y = Annual)) +  geom_point() + geom_smooth(method = 'lm') + labs(y = "Degree")})
  })
  
})
