data=read.table("all.depth",header = 1,row.names = 1)
data=na.omit(data)
group=read.table("groups.txt",header = F,stringsAsFactors = T)
rpkm=as.data.frame(apply(data, 2, function(x){sum(x>1)}))
rpkm$group=group$V1
rpkm$treatment=group$V2
colnames(rpkm)[1]="value"
library(ggplot2)
p=ggplot(rpkm,aes(treatment,value,fill=treatment))+geom_boxplot()
p

relative_abundance=function(d){
  dta_sum=apply(d,2,function(x){x/sum(x)})
}
sum=apply(data,1,function(x){max(x)})

data_20=data[sum>50,]
results4_1=relative_abundance(data_20)
library(dplyr)
library(vegan)

###shared populations
nd=matrix(NA,0,0)
abu_vc_2=results4_1
for (i in 1:ncol(abu_vc_2)){
  col=as.matrix(abu_vc_2[,i])
  rownames(col)=rownames(abu_vc_2)
  col=as.matrix(col[col[,1]>0.0001,])
  colnames(col)=colnames(abu_vc_2)[i]
  nd=as.matrix(new.cbind(nd,col))
}

for(i in 1:nrow(nd)){
  for (j in 1:ncol(nd)){
    if(is.na(nd[i,j])==FALSE){
      nd[i,j]=1
    }
    else{
      nd[i,j]=0
    }
  }
}

group_non=group[grep(pattern = "Non_mitomycin_C",group$V3),]
binary=matrix(NA,nrow(nd),ncol = 25)
for (i in 1:nrow(group_non)){
  temp=nd[,grep(pattern = group_non[i,4],colnames(nd))]
  temp_1=as.matrix(apply(temp,1,sum))
  temp_1[temp_1[,1]>1,]=1
  binary[,i]=temp_1
}
rownames(binary)=rownames(nd)
colnames(binary)=group_non$V4
nd=as.data.frame(binary)

share=matrix(NA,ncol(nd),ncol(nd))
for (i in 1:ncol(nd)){
  for (j in 1:ncol(nd)){
    print(j)
    sum=as.matrix(apply(nd[,c(i,j)],1,sum))
    shared=as.data.frame(nrow(nd[sum==2,]))
    if(nrow(shared)>0){
    a=sum(nd[,i])
    b=sum(nd[,j])
    viral_shared_content=((shared/a)+(shared/b))/2
    share[i,j]=viral_shared_content[1,1]
    }else{
      share[i,j]==0
      }
  }
}

colnames(share)=colnames(nd)
rownames(share)=colnames(nd)
share[is.na(share)]=0
# 获得相关矩阵的下三角元素
# Get lower triangle of the correlation matrix
get_lower_tri<-function(cormat){
  cormat[upper.tri(cormat)] <- NA
  return(cormat)
}
share1=get_lower_tri(share)

library(reshape2)
share1=melt(share1)
share1=na.omit(share1)
share1=share1[share1$value!=1,]
share1=as.data.frame(share1)

nd=matrix(NA,nrow(share1),1)
library(dplyr)
for (i in 1:nrow(share1)){
  print(i)
  name=as.matrix(group[grep(share1[i,1],group_non$V4),1])
  name_1=as.matrix(group[grep(share1[i,2],group_non$V4),1])
  if(name_1[1,1]==name[1,1]){
    nd[i,1]="within_group"
  }else{
    nd[i,1]="between_group"
  }
}
share1$group=nd
summary(share1[grep("inter",share1$zone),3])
nd=matrix(NA,nrow(share1),1)
for (i in 1:nrow(share1)){
  print(i)
  name=as.matrix(group[grep(share1[i,1],group_non$V4),2])
  name_1=as.matrix(group[grep(share1[i,2],group_non$V4),2])
  if(name_1[1,1]==name[1,1]){
    nd[i,1]="intra zone"
  }else{
    nd[i,1]="inter zone"
  }
}

share1$zone=nd
library(ggplot2)
library(ggpubr)
share1=as.data.frame(share1)
p=ggplot(share1,aes(zone,value))+
  geom_boxplot(fill="lightblue")+
  theme(axis.text = element_text(color = "black"),
        axis.title.x = element_blank(),
        axis.text.x = element_text(angle = 60,size = 10,hjust = 1),
        legend.key.size = unit(5, 'mm'),
        legend.text = element_text(size = 10))+
  theme(panel.grid = element_line(color = 'gray', linetype = 2, size = 0.2), 
        panel.background = element_rect(color = 'black', fill = 'transparent'), 
        legend.key = element_rect(fill = 'transparent')) +
  geom_vline(xintercept = 0, color = 'gray', size = 0.4) + 
  geom_hline(yintercept = 0, color = 'gray', size = 0.4)

p+stat_compare_means(value ~ group, data = share1,
                      method = "wilcox.test",label="p.signif",paired = F,
                      comparisons =list(c("inter zone","intra zone")))
  
share1=get_lower_tri(share)

library(pheatmap)
annotation_row=as.data.frame(group_non[,c(1,2)])
rownames(annotation_row)=group_non[,4]
colnames(annotation_row)=c("type","zone")

pheatmap(share,cutree_rows = 3,cutree_cols =3,
         border_color = "grey",
         color = colorRampPalette(c("white","black"))(20),
         clustering_method = "average",
         annotation_col = annotation_row)



