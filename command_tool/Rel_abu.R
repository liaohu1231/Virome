library('getopt')
 
command=matrix(c( 
  'help', 'h', 0,'character',
  'input', 'i', 1, 'character',
  'output', 'o', 1, 'character'),byrow=T,ncol=4)
  
args=getopt(command)

if (!is.null(args$help) || is.null(args$input) || is.null(args$output) ) {
  cat(paste(getopt(command, usage = T), "\n"))
  q(status=1)
}

###new.cbind函数；能够整合两个不相等的矩阵###
new.cbind <- function(...)
{
  input <- eval(substitute(list(...), env = parent.frame()))
  
  names.orig <- NULL
  nrows <- numeric()
  for (i in 1:length(input))
  {
    nrows[i] <- nrow(input[[i]])
    names.orig <- c(names.orig, colnames(input[[i]])) 
  }
  
  idx <- (1:length(input))[order(nrows, decreasing=T)]
  x <- NULL
  for (i in 1:length(input))
  {
    x <- c(x, rownames(input[[idx[i]]]))
  }
  
  r <- data.frame(row.names=unique(x))
  for (i in 1:length(input))
  {
    r <- cbind(r, data.frame(input[[i]][match(rownames(r), rownames(input[[i]])),]))
  }
  
  colnames(r) <- names.orig
  
  return(r)
}

relative_abundance=function(d){
  dta_sum=apply(d,2,function(x){x/sum(x)})
} #计算相对丰度

data=read.table(args$input, sep="\t",header = 1, row.names = 1)
dtat=data[!rownames(data) %in% c("Contig"),]

a=apply(dtat,1,function(x){sum(x == 0)/length(x)})
dta=dtat[a<0.95,]

dtat=dta
head(dtat)
dtat[is.na(dtat)]=0
data=apply(dtat,2,function(x){as.numeric(as.character(x))})
dtat=t(dtat)
data=t(data)
colnames(data)=colnames(dtat)
colnames(data)=paste(sapply(strsplit(colnames(data),split = ";"),"[",2),";",sapply(strsplit(colnames(data),split = ";"),"[",3))
head(data)
colnames(data)=paste(sapply(strsplit(colnames(data),split = "_"),"[",1))
head(data)
sum_same_col=function(x){
  t=table(colnames(x))
  nd<-matrix(0,length(t),ncol=length(rownames(x))) #得到一个矩阵,元素都为0,行数为t的个数，列数为d的变量个数减1
  for(i in 1:length(t)){
    index<-which(colnames(x) %in% names(t)[i])    #此行为匹配,把data的列名和t的第i个变量名进行匹配，并返回匹配到的下表值
    if(length(index)==1) 
      nd[i,]<-data[1:length(rownames(x)),index]   #当只匹配到一个值时，就不求平均值了，直接存储就行了
    else 
      nd[i,]<-rowSums(data[1:length(rownames(x)),index])

    #rownames(nd)=rownames(data)
  }
  t=as.matrix(t)
  rownames(nd)=rownames(t)
  colnames(nd)=rownames(x)
  return(nd)
}

new_dat=sum_same_col(x = data)
new_dat["unclassified ; NA",]=new_dat["unclassified ; NA",]+new_dat["no",]
new_dat=new_dat[-8,]
#new_dat=new_dat[,-108]

#当匹配到多个值时，对匹配到的值求平均值，存储到响应的nd位置
head(new_dat)
library(ggplot2)
library(reshape2)
library(ggsci)
new_dat=relative_abundance(new_dat)
new_dat=new_dat[,order(new_dat[10,],decreasing = T)]
taxno=melt(new_dat)
p <- ggplot(data=taxno, aes(x=Var2, y=value,color=Var1))+geom_bar(stat="identity", width=0.7)
map=p+theme(text = element_text(size=8),axis.text.x = element_text(angle=60, hjust=1.0,colour = "white",size = 0))+
  theme(legend.key.size=unit(5,'mm'))+scale_fill_discrete(name="Viral name")+
  theme(legend.spacing.x = unit(0.1, 'cm'),legend.key.size = unit(5, 'cm'))+
  scale_color_aaas()+
  labs(y="Relative abundance",x="Samples")+
  #scale_color_manual(values=c('#999999','#E69F00',"red","blue","#FFFF00",
  #                            "#FF99FF","#CC9900","#CC66FF","#993333","#33FFFF",
  #                            "grey","green","#66FF00","#66CC00","#666633",
  #                            "#333366","#003300","#330033","#CC9909","#99FFCC",
  #                           "#336666","#99CC66","#CC3333","#33CCCC","#CC6600",
  #                            "#FFCC66","#FFFFCC","#FF9900","#FF6633","#CC9999"))+
  guides(color = guide_legend(ncol = 1, 
                              byrow = TRUE,
                              keywidth = 0.1,
                              keyheight = 0.1,
                              title = "Family"))
ggsave(filename=args$output,device="pdf",width=7,height=4)
