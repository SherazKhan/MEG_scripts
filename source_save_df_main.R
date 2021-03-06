source_save_df_main <-function(filePrefix,t1,t2){
	
filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/source_space/R/"
fileName <- paste(filePath,filePrefix,t1,"-",t2,".txt",sep="")
buffer<-read.table(fileName)
sourceData.all<-data.frame(subj=factor(buffer$V1),cond=factor(buffer$V2),roi=factor(buffer$V3),hemCode=factor(buffer$V4),amp=buffer$V5)


outFile <- paste(filePath,filePrefix,t1,"-",t2,".df",sep="")
save(sourceData.all,file=outFile)
}