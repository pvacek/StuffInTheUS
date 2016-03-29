#Build Plots
library(ggplot2)
library(plyr)
library(dplyr)
library(ggthemes)

joinTables<-function(var1,var2,v1t="layer",v2t="layer",roundto="1"){
  df1<-mainlist[[roundto]][[v1t]][[var1]]
  df2<-mainlist[[roundto]][[v2t]][[var2]]
  if(nrow(df1) > nrow(df2)){bigdf<-df1;smalldf<-df2;bigdfvar<-var1;smalldfvar<-var2}
  else{bigdf<-df2;smalldf<-df1;bigdfvar<-var2;smalldfvar<-var1}
  bigdf<-data.frame(bigdf[,1:2],v1=bigdf[,3],rloc=paste(bigdf[,1],bigdf[,2]))
  smalldf<-data.frame(smalldf[,1:2],v2=smalldf[,3],rloc=paste(smalldf[,1],smalldf[,2]))
  bigdf_newvals<-do.call(rbind,strsplit(as.character(smalldf$rloc[which(smalldf$rloc %in% bigdf$rloc == FALSE)])," "))
  smalldf_newvals<-do.call(rbind,strsplit(as.character(bigdf$rloc[which(bigdf$rloc %in% smalldf$rloc == FALSE)])," "))
  if(class(bigdf_newvals) != "NULL"){bigdf<-do.call(rbind,list(bigdf[,1:3],data.frame(rlong=as.numeric(bigdf_newvals[,1]),rlat=as.numeric(bigdf_newvals[,2]),
                                                   v1=rep(0,nrow(bigdf_newvals)))))}
  if(class(smalldf_newvals) != "NULL"){smalldf<-do.call(rbind,list(smalldf[,1:3],data.frame(rlong=as.numeric(smalldf_newvals[,1]),rlat=as.numeric(smalldf_newvals[,2]),
                                                       v2=rep(0,nrow(smalldf_newvals)))))}
  bigdf<-bigdf[with(bigdf,order(rlong,rlat)),]
  smalldf<-smalldf[with(smalldf,order(rlong,rlat)),]
  joindf<-join(bigdf,smalldf)
  joindf[is.na(joindf[,4]),4]<-0
  names(joindf)[3:4]<-c(bigdfvar,smalldfvar)
  return(joindf)
}

plotMap<-function(var1,v1t="layer",roundto="1"){
  popdf<-mainlist[[roundto]][["PPL"]][["PPL"]]
  plotdf<-mainlist[[roundto]][[v1t]][[var1]]
  plotdf[which(plotdf[,3] >= quantile(plotdf[,3],probs=.95)),3] = quantile(plotdf[,3],probs=.95)
  midpoint<-(max(plotdf[,3])-min(plotdf[,3]))/2
  ggus<-ggplot()+geom_point(data=popdf,aes(x=rlat,y=rlong),shape=21,size=5*as.numeric(roundto),alpha=.4)
  ggus<-ggus+geom_point(data=plotdf,aes(x=rlat,y=rlong,color=plotdf[,3]),size=3*as.numeric(roundto),alpha=.8)
  ggus<-ggus+scale_color_gradient2(low="darkgreen",mid="yellow",high="red",midpoint=midpoint,
                                   breaks=c(max(plotdf[,3]),min(plotdf[,3])),
                                   labels=c(paste0("More ",var1),paste0("Less ",var1)))
  ggus<-ggus+labs(x="",y="")+theme_tufte()+theme(legend.title=element_blank(),axis.text=element_blank(),
                                                 axis.ticks=element_blank())
  ggus<-ggus+coord_cartesian(xlim=c(-125,-67),ylim=c(24,50))
  ggus
}

plotTwoMaps<-function(var1,var2,v1t="layer",v2t="layer",roundto="1"){
  if(var1==var2){return(plotMap(var1,v1t,roundto))}
  popdf<-mainlist[[roundto]][["PPL"]][["PPL"]]
  plotdf<-joinTables(var1,var2,v1t,v2t,roundto)
  plotdf<-mutate(plotdf,diff=log(plotdf[,3]+1)-log(plotdf[,4]+1))
  plotdf$diff[plotdf$diff >= abs(min(plotdf$diff))]=abs(min(plotdf$diff))
  plotdf$diff[plotdf$diff <= -max(plotdf$diff)]=-max(plotdf$diff)
  ggus<-ggplot()+geom_point(data=popdf,aes(x=rlat,y=rlong),shape=21,size=5*as.numeric(roundto),alpha=.4)
  ggus<-ggus+geom_point(data=plotdf,aes(x=rlat,y=rlong,color=diff),size=3*as.numeric(roundto),alpha=.8)
  ggus<-ggus+scale_color_gradient2(low="darkgreen",mid="yellow",high="red",
                                   breaks=c(max(plotdf$diff),min(plotdf$diff)),labels=c(paste0("More ",names(plotdf)[3]),paste0("More ",names(plotdf[4]))))
  ggus<-ggus+labs(x="",y="")+theme_tufte()+theme(legend.title=element_blank(),axis.text=element_blank(),
                                                 axis.ticks=element_blank())
  ggus<-ggus+coord_cartesian(xlim=c(-125,-67),ylim=c(24,50))
  ggus
}