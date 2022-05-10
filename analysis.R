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
results4_1=na.omit(results4_1)
results5=t(results4_1)
results5=as.matrix(results5)

###distance
library(vegan)
distance <- as.matrix(vegdist(results5, method= "bray",na.rm = T))
colnames(distance)=rownames(results5)
rownames(distance)=rownames(results5)
melt_distance=distance
melt_distance$names=rownames(melt_distance)
melt_distance=melt(melt_distance)
melt_distance=melt_distance[melt_distance$value>0.0,]
nd=matrix(NA,nrow(melt_distance),1)
library(dplyr)
for (i in 1:nrow(melt_distance)){
  print(i)
  j=paste("C",melt_distance[i,2],sep = "")
  if(melt_distance[i,1]== as.character(j) || melt_distance[i,1]== melt_distance[i,2]){
    nd[i,1]="intra_site"
  }else{
    nd[i,1]="inter_site"
  }
}
summary(melt_distance[grep(pattern = "intra",melt_distance$group),3])
melt
nd=matrix(NA,nrow(melt_distance),1)
library(dplyr)
for (i in 1:nrow(melt_distance)){
  print(i)
  j=paste("C",melt_distance[i,2],sep = "")
  if(melt_distance[i,1]== as.character(j) || melt_distance[i,1]== melt_distance[i,2]){
    nd[i,1]="intra_site"
  }else{
    nd[i,1]="inter_site"
  }
}
melt_distance$group=nd
p=ggplot(melt_distance,aes(group,value))+
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

p+stat_compare_means(value ~ group, data = melt_distance,
                     method = "wilcox.test",label="p.signif",paired = F,
                     comparisons =list(c("inter_site","intra_site")))

pcoa_v <- cmdscale(distance, k = (nrow(results5) - 1), eig = TRUE)
point_v <- data.frame(pcoa_v$point)
#species <- wascores(pcoa$points[,1:2], results5)
#坐标轴解释量（前两轴）
pcoa_eig_v <- (pcoa_v$eig)[1:2] / sum(pcoa_v$eig)
#提取样本点坐标（前两轴）
sample_site_v <- data.frame ({pcoa_v$point})[1:3]
#为样本点坐标添加分组信息
sample_site_v$names <- rownames(sample_site_v)
names(sample_site_v)[1:3] <- c('PCoA1', 'PCoA2','PCoA3')

rownames(group)=group$V4
sample_site_v$group=group[as.character(rownames(sample_site_v)),3]
sample_site_v$type=group[as.character(rownames(sample_site_v)),1]
sample_site_v$zone=group[as.character(rownames(sample_site_v)),2]
nd=sample_site_v[,5:7]
results5=as.data.frame(results5)
#nd$type=as.character(nd$type)

p_value=anosim(x = results5[1:50,],grouping = nd$type,distance = "bray",permutations = 9999)
summary(p_value)
p_value_2=anosim(t(data),nd$zone,permutations = 9999,distance = "bray")
summary(p_value_2)
p_value_2=anosim(results5,nd$group,permutations = 9999,distance = "bray")
summary(p_value_2)
library(ggplot2)
library(ggsci)
p <- ggplot(sample_site_v, aes(PCoA1, PCoA2,group = group,color=zone)) +
  theme(panel.grid = element_line(color = 'gray', linetype = 2, size = 0.2), 
        panel.background = element_rect(color = 'black', fill = 'transparent'), 
        legend.key = element_rect(fill = 'transparent')) +
  geom_vline(xintercept = 0, color = 'gray', size = 0.4) + 
  geom_hline(yintercept = 0, color = 'gray', size = 0.4) +
  #geom_polygon(data = group_border, aes(fill=Group)) + #绘制多边形区域
  geom_point(size = 4, alpha = 0.8) + #可在这里修改点的透明度、大小
  #scale_shape_manual(values = c(20, 18))+  #可在这里修改点的形状
  scale_color_lancet() + #可在这里修改点的颜色
  labs(x = paste('PCoA axis1: ', round(100 * pcoa_eig_v[1], 2), '%'), 
       y = paste('PCoA axis2: ', round(100 * pcoa_eig_v[2], 2), '%'))+
  stat_ellipse(data = sample_site_v,mapping = aes(PCoA1, PCoA2,group = zone),level = 0.95, show.legend = TRUE,inherit.aes = F)+
  stat_ellipse(data = sample_site_v,mapping = aes(PCoA1, PCoA2,group = zone),level = 0.975, show.legend = TRUE,inherit.aes = F)+
  annotate('text', colour="#8766d")
p
###信息熵
library(entropy)
xinxishang=as.data.frame(apply(data, 2, entropy))
##alpha
library(vegan)
library(ggpubr)
data=read.table("all.depth",header = 1,row.names = 1)
data_abu=as.data.frame(relative_abundance(data))
data_norm_shannon=as.data.frame(diversity(t(data_abu), "shannon"))

###simpson
data_norm_simpson=as.data.frame(diversity(t(data_abu), "simpson"))
data_norm_shannon=data_norm_simpson

summary(data_norm_simpson$`diversity(t(data_abu), "simpson")`)
sp1 <- specaccum(t(data_abu), method="random")
plot(sp1, ci.type="poly", col="blue", lwd=2, ci.lty=0, ci.col="grey")
boxplot(sp1, col="lightblue", add=TRUE, pch="+")

S <- as.data.frame(specnumber(t(data_abu)))
J <- as.data.frame(data_norm_shannon/log(S))

data_norm_shannon[,2]=colnames(data)
colnames(data_norm_shannon)=c("alpha","sample")
library(reshape2)
rownames(group)=group$V4
data_norm_shannon$zones=group[rownames(data_norm_shannon),2]
data_norm_shannon$type=group[rownames(data_norm_shannon),1]
data_norm_shannon$treatment=group[rownames(data_norm_shannon),3]

alpha=melt(data_norm_shannon)
summary(alpha$value)
library(ggplot2)
library(ggsci)
p=ggplot(alpha,aes(zones,value,fill=treatment))+
  geom_boxplot()+
  theme(axis.text.x = element_text(angle = 60,hjust = 1))+
  labs(x="Treatment",y="Simpson index")+
  scale_fill_lancet()+theme_bw()
p
p+stat_compare_means(value ~ type, data = alpha,
                     method = "t.test",label="p.signif",paired = F,
                     comparisons =list(c("FO","PT"),c("FO","PV"),c("PV","PT")
                                       ))
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

###Z-score
Zscore<-function(x){
  for(i in 1:ncol(x)){
    c=(x[,1:ncol(x)]-apply(x[,1:ncol(x)],2,mean))/apply(x[,1:ncol(x)],2,var)
  }
  return(c)
}

Z_result4_1=Zscore(results4_1)
Z_result4_1=as.data.frame(t(Z_result4_1))
rownames(group)=group$V3
Z_result4_1$group=as.factor(group[as.character(rownames(Z_result4_1)),1])
Z_result4_1$treatment=as.factor(group[as.character(rownames(Z_result4_1)),2])
Z_result4_1=Z_result4_1[order(Z_result4_1$group,decreasing = T),]
Z_result4_1=Z_result4_1[order(Z_result4_1$treatment,decreasing = T),]
Z_result4_1=as.data.frame(t(Z_result4_1))
annotation_col=as.data.frame(t(Z_result4_1[9650:9651,]))
Z_result4_1=Z_result4_1[-c(9650:9651),]
Z_result4_1=apply(Z_result4_1, 2, as.numeric)
rownames(Z_result4_1)=rownames(results4_1)

###
library(vegan)
library(pheatmap)
library(dplyr)

summary(p_value)
data=read.table("all.depth",header = 1,row.names = 1)
#data=data[,c(21:25,1:5,16:20,6:10,11:15,46:50,26:30,41:45,31:35,36:40)]
data_sample=matrix(NA,nrow = nrow(data),0)
data=as.data.frame(data)
for (i in 1:ncol(data)){
  col=as.matrix(data[,i])
  rownames(col)=rownames(data)
  col=as.matrix(col[col[,1]>20,])
  colnames(col)=colnames(data)[i]
  data_sample=as.matrix(new.cbind(data_sample,col))
}
data_sample=sample_n(tbl = as.data.frame(data),size = 20000,replace = F)
data_sample=relative_abundance(data_sample)
data_sample=as.data.frame(data_sample)
sum=apply(data_sample, 1, sum)
data_sample=data_sample[sum>0,]
distance=as.data.frame(distance)

pheatmap(distance,
         border_color = F,
         color = colorRampPalette(c("black","white"))(10),
         show_rownames = T,
         show_colnames = T,
         annotation_col=annotation_col,clustering_method = "average",
         clustering_distance_rows = "euclidean",
         clustering_distance_cols = "euclidean",
         cluster_cols = T,
         cellheight = 3)


###dissemination of viral
num=apply(data,1,function(x){sum(x>5)})
head(num)
p=as.matrix(num/50)
p_1=as.matrix(p[p[,1]>0.3,])
dissem=data[p[,1]>0.3,]
##network

###reads
map=read.table("mapped_virus.txt",sep=" ")
nd=matrix(NA,nrow(sample_site_v),2)
for (i in 1:nrow(map)){
  name=as.matrix(group[grep(pattern = map[i,1],group$V3),1:2])
  nd[i,1:2]=name[1,1:2]
}
map$type=as.factor(nd[,1])
map$group=as.factor(nd[,2])
map$percent=map[,2]/30000000
summary(map$percent)


