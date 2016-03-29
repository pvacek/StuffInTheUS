#Map Script Server

library(shiny)
source("https://raw.githubusercontent.com/pvacek/StuffInTheUS/master/ScriptFiles/mapmaker.R")
load(url("https://github.com/pvacek/StuffInTheUS/raw/master/ScriptFiles/featurecodes.rda"))

shinyServer(function(input,output){
  output$map<-renderPlot({
    dataInput<-reactive({
      data<-as.character(featurecodes[featurecodes[,2]==input$var1,1][1])
      round<-as.character(input$round)
      return(list(data,round))})
    data<-dataInput()
    plotMap(var1=data[[1]],v1t="layer",roundto=data[[2]])
  })
})
