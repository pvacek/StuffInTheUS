#Map Script UI

library(shiny)
load(url("https://github.com/pvacek/StuffInTheUS/raw/master/ScriptFiles/fullnameslayer.rda"))

shinyUI(fluidPage(
  titlePanel("Where Stuff is in the U.S."),
  sidebarLayout(sidebarPanel(helpText("Create cool maps of the U.S."),
                              selectInput("var1",label="Choose an item to visualize",
                                          choices=fullnames_layer,
                                          selected=fullnames_layer[1]),
                             selectInput("round",label="choose a point size",
                                         choices=c("0.25","0.5","1","2"),
                                         selected="1")),
                              mainPanel(plotOutput("map"),
                                        h6("Version 0.1, created by pvacek",align="left",style="color:blue")))))