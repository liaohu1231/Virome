args=commandArgs(T)
data=read.table(args[1],header=1,row.names=1)
groups=read.table("groups.txt",header=1)
groups=as.data.frame(groups)
group_non=groups[grep(pattern = "Non_mitomycin_C",groups$treatment),]
#merge NMT and MT optiminal
binary=matrix(NA,nrow(data),25)
for (i in 1:nrow(group_non)){
  print(i)
  temp=data[,grep(pattern = group_non[i,4],colnames(data))]
  temp_1=as.matrix(apply(temp,1,sum))
  binary[,i]=temp_1[,1]
}
colnames(binary)=group_non[,4]
rownames(binary)=rownames(data)
data=binary
rownames(group_non)=group_non[,4]
data_1=t(data)
head(group_non)
rownames(data_1)
data_1=as.data.frame(data_1)
data_1$zones=group_non[as.character(rownames(data_1)),2]
data_2=data
colnames(data_2)=data_1$zones
source("sum_sam_colnames.R")
zones=sum_same_col(data_2)
zones=as.data.frame(t(zones))
rownames(zones)=rownames(data)
write.table(zones,"zones.tsv",quote=F,sep="\t",row.names=TRUE)

nd=matrix(NA,nrow(data_2),1)
rownames(nd)=rownames(data_2)
head(nd)

number=function(data){
number=apply(data,1,function(x){
 a=sum(x>0)
 return(a)})
}

local=as.matrix(number(data))
zone=as.matrix(number(zones))

nrow(local)
head(zone)
nd=as.data.frame(nd)
for (i in 1:nrow(data)){
if (local[i,1]==1){
nd[i,1]="zone_specific_local"
}else if (local[i,1]>1 && zone[i,1]==1){
nd[i,1]="zone_special_regional"
}else if (local[i,1]>1 && zone[i,1]>1){
nd[i,1]="multi_zonal"
}
}
write.table(nd,"classified_populations.tsv",quote=F,sep="\t",row.names=TRUE)

