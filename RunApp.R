#Run the app, install any packages if needed

#packages<-c("ggplot2","dplyr","ggthemes","shiny")
#install.packages(packages)

ui<-"https://raw.githubusercontent.com/pvacek/StuffInTheUS/master/ScriptFiles/ui.R"
server<-"https://raw.githubusercontent.com/pvacek/StuffInTheUS/master/ScriptFiles/server.R"

source(ui)
source(server)

runApp(list(ui,server))