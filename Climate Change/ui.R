library(shiny)
#library(shinyWidgets)
library(shinythemes)
library(markdown)
library(leaflet)



navbarPage(
    title = "Cilimate Change",
    theme = shinytheme("flatly"),  
    tabPanel(HTML('<em>CO</em><sub>2</sub> level'),
             
             
             sidebarLayout(
                 sidebarPanel(
                   
                     width = 3,
                     
                     selectInput("range", 
                                 label = "Choose a surface range to display: ",
                                 choices = list("Northern Hemisphere", "Worldwide"),
                                 selected = "Northern Hemisphere"),
                     
                     conditionalPanel(
                         condition = "input.range == 'Northern Hemisphere'",
                         #sliderTextInput("latitude",
                         selectInput("latitude",
                                     label ="Latitude: ", 
                                     choices = list("30", "33", "37", "41", "44", "49", "53", "58", "64", "72", "90"), 
                                     selected = "49") #, grid = TRUE, force_edges = TRUE)
                         
                     )
                 ),
                 
                 mainPanel(
                     h4(textOutput("latitle"), align = "center"),
                     
                     plotOutput("co2plot"),
                     
                     p("Reference: ", br(), "Dlugokencky, E.J., K.W. Thoning, P.M. Lang, and P.P. Tans (2017), NOAA Greenhouse Gas Reference from 
            Atmospheric Carbon Dioxide Dry Air Mole Fractions from the NOAA ESRL Carbon Cycle Cooperative Global Air Sampling 
                           Network.", br(), "Data Path: ", br(), em("ftp://aftp.cmdl.noaa.gov/data/trace_gases/co2/flask/surface/"))
                 )
             )
             
    ),
    
    tabPanel("Canadian Temperature",
             
             div(class="outer", 
                 tags$head(includeCSS("styles.css")),
                 
                 leafletOutput("tempmap", width = "100%", height = "100%"),
                 
                 absolutePanel(id = "control", class = "panel panel-default", fixed = TRUE,
                               draggable = TRUE, top = 85, left = 20, right = "auto", bottom = "auto",
                               width = 380, height = "auto",
                               
                               h4("Tempurature in Different Region"),
                               
                               sliderInput("month1", "Month: ",
                                           min = 1, max = 12,
                                           value = 1, animate = TRUE),
                               
                               numericInput("year1", "Year: ",
                                            min = 1899, max = 2017,
                                            value = 2017),
                               
                               radioButtons("temp", label = "Canadian Temperature",
                                            choices = list("Max Temp", "Mean Temp", "Min Temp"), 
                                            selected = "Mean Temp"),
                               textOutput("avg"),
                               plotOutput("avgtemp"),
                               
                               p("Reference: ", br(), "Adjusted and Homogenized Canadian Climate Data (AHCCD)", br(), em("http://data.ec.gc.ca/data/climate/scientificknowledge/adjusted-and-homogenized-canadian-climate-data-ahccd/"))
                               
                               
                 )
                 
             )
             
    ),
    
    tabPanel("Canadian Snowfall & Precipitation",
             sidebarLayout(
                 sidebarPanel(
                   
                     width = 3,
                     
                     sliderInput("year", "Year: ",
                                 min = 1899, max = 2017,
                                 value = 2010, animate = TRUE),
                     
                     sliderInput("month", "Month: ",
                                 min = 1, max = 12,
                                 value = 1, animate = TRUE),
                     
                     radioButtons("Province", 
                                  label = "Province: ",
                                  choices = list("BC", "YK", "NT", "NU", "AB", "SK", "MB", "ON", "QC", "NB", "NS", "PE", "NL"),
                                  selected = "BC")
                     
                 ),
                 mainPanel(
                     
                     h4("Average Annual Snowfall & Precipitation for each Province", align = "center"),
                     
                     plotOutput("circle", width = "100%", height = 600),
                     
                     #br(),
                     
                     h4(textOutput("detitle"), align = "center"),
                     
                     plotOutput("density"),
                     
                     p("Reference: ", br(), "Adjusted and Homogenized Canadian Climate Data (AHCCD)", br(), em("http://data.ec.gc.ca/data/climate/scientificknowledge/adjusted-and-homogenized-canadian-climate-data-ahccd/"))
                     
                 )
             )
    ),
    
    tabPanel("About", source("about.R")$value()) 
    
    
)
