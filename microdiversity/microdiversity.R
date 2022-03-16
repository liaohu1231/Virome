args=commandArgs(T)
print("parament 1 is nucleotic diversity file from output of instrain，parament 2 is a classified files for geographic distribution of viral populations")
all_pi = read.csv(args[1],header=1,row.names=1,sep='\t')
#contigs = read.table(args[3],header=T,sep='\t')
classified=read.table(args[2],header=1,row.names=1,sep="\t")
###
head(classified)
group=read.table("groups.txt",header=1)
rownames(group)=group[,4] ## metadata files
library(reshape2)
#all_pi$contigs=contigs[,1]

all_pi$classified=classified[as.character(rownames(all_pi)),1]
print(all_pi$classified)
nd=matrix(NA,3,50)
for (i in 1:50){
a=as.matrix(all_pi[grep("multi",all_pi$classified),i])
b=as.matrix(all_pi[grep("regional",all_pi$classified),i])
c=as.matrix(all_pi[grep("local",all_pi$classified),i])
a=as.data.frame(as.numeric(na.omit(a[,1])))
#print(a)
a=as.matrix(a[a[,1]>0,])
b=as.data.frame(as.numeric(na.omit(b[,1])))
b=as.matrix(b[b[,1]>0,])
c=as.data.frame(as.numeric(na.omit(c[,1])))
head(c)
c=as.matrix(c[c[,1]>0,])
a_1=matrix(NA,1000,1)
b_1=matrix(NA,1000,1)
c_1=matrix(NA,1000,1)

for (j in 1:1000){
if(nrow(a)>5){
a_1[j,]=mean(a[sample(1:nrow(a),size=5,replace=F),1])
}else{
a_1[j,]=mean(a[,1])
}
#print(a_1)
if (nrow(c)>10 ){
c_1[j,]=mean(c[sample(1:nrow(c),size=10,replace=F),1])
}else{
c_1[j,]=mean(c[,1])
}
if(nrow(b)>20){
b_1[j,]=mean(b[sample(1:nrow(b),size=20,replace=F),1])
}else{
b_1[j,1]=mean(b[,1])
}
}
nd[1,i]=mean(a_1[,1])
nd[2,i]=mean(b_1[,1])
nd[3,i]=mean(c_1[,1])
}
rownames(nd)=c("multi","regional","local")
colnames(nd)=colnames(all_pi[,1:50])
nd=as.data.frame(nd)
head(nd)
nd$classified=rownames(nd)
#write.table(nd,"microdiversity_pNpS_populations.tsv",quote=F)
all_pi=melt(nd)
#all_pi=all_pi[all_pi$value>0,]
all_pi=na.omit(all_pi)
all_pi=as.data.frame(all_pi)
all_pi$zone=as.factor(group[as.character(all_pi$variable),2])
all_pi$classified=factor(all_pi$classified,level=c("local","regional","multi"))
#all_pi$value=log(all_pi$value)
#all_pi=all_pi[grep("multi",all_pi$classified),]
print(all_pi)
library(ggplot2)
library(ggpubr)
p=ggplot(all_pi,aes(x=classified,y=value))+
  geom_boxplot(aes(fill=zone,color=zone,alpha=0.4),outlier.shape=21)+
  facet_wrap(~zone,ncol=3) +
  labs(y="Microdiversity")+
  theme(axis.text = element_text(color = "black"),
        axis.title.x = element_blank(),
        axis.text.x = element_text(angle = 60,size = 10,hjust = 1),
        legend.key.size = unit(5, 'mm'),
        legend.text = element_text(size = 10))+
  theme(panel.grid = element_line(color = 'gray', linetype = 2, size = 0.2), 
        panel.background = element_rect(color = 'black', fill = 'transparent'), 
        legend.key = element_rect(fill = 'transparent')) +
  geom_vline(xintercept = 0, color = 'gray', size = 0.4) + 
  geom_hline(yintercept = 0, color = 'gray', size = 0.4)+
	stat_compare_means(value ~ classified, data =all_pi,na.rm=TRUE,
                     method = "wilcox.test",label="p.signif",paired = F,
#comparisons =list(c("PV","FO"),c("FO","PT"),c("PT","PV")))                     
comparisons =list(c("multi","regional"),c("regional","local"),c("local","multi")))
library(gg.gap)
p=gg.gap(p,segments=c(0.015,0.03),ylim=c(0,0.045),rel_heights=c(2,0,0.5))
ggsave(filename="microdiversity_populations_zone.pdf",p,width=7,height=6,device='pdf')
