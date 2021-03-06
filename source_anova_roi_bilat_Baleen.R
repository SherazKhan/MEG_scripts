source_anova_roi_bilat_Baleen <-function(filePrefix,t1,t2,testroi){

library('ez')

filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/source_space/R/"
load(paste(filePath,filePrefix,t1,"-",t2,".df",sep=""))
outfile <-paste(filePath,filePrefix,t1,"-",t2,"_anova_",testroi,"_bilat.txt",sep="")
sink(outfile)

sourceData.all$prime<-factor(sourceData.all$cond,exclude=NULL)
levels(sourceData.all$prime)<-c("rel","unrel","rel","unrel")
sourceData.all$prop<-factor(sourceData.all$cond,exclude=NULL)
levels(sourceData.all$prop)<-c("hi","hi","lo","lo")


sourceData.roi <- subset(sourceData.all,roi==testroi)

eztest <-ezANOVA(data=sourceData.roi,dv = .(amp),wid=.(subj),within=.(prime,prop,hemCode),type=3,detailed=TRUE)
print("2x2x2 relatedness x proportion x hem") 
print(eztest)


#####Within Low Proportion ANOVA####

sourceData.roi.lo <-subset(sourceData.roi,prop=="lo")

eztest <-ezANOVA(data=sourceData.roi.lo,dv = .(amp),wid=.(subj),within=.(prime,hemCode),type=3,detailed=TRUE)
print("Lo")
print(eztest)

#####Within High Proportion ANOVA####

sourceData.roi.hi <-subset(sourceData.roi,prop=="hi")

eztest <-ezANOVA(data=sourceData.roi.hi,dv = .(amp),wid=.(subj),within=.(prime,hemCode),type=3,detailed=TRUE)
print("Hi")
print(eztest)


#####Print the marginal means
sourceData.roi.aov <- aov(amp ~ prime * prop * hemCode + Error(subj/(prime * prop * hemCode)),data=sourceData.roi)
print("Marginal Means")
print(model.tables(sourceData.roi.aov,"means"),digits=5)


sink()
}