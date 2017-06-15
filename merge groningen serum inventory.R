### Objective: Merge inventory files of Groningen 

###A new folder was created to compile all inventory docs of Groningen, named "master_inventory" 
choose.dir()
setwd("C:\\Users\\korinna\\Documents\\Docteral\\F75\\data cleaning practise code\\master_groningen_inventory")
#import files
choose.files()
d1<-read.csv("C:\\Users\\korinna\\Documents\\Docteral\\F75\\data cleaning practise code\\master_groningen_inventory\\CSV files\\F75_INV_28-02_m.csv")
d2<-read.csv("C:\\Users\\korinna\\Documents\\Docteral\\F75\\data cleaning practise code\\master_groningen_inventory\\CSV files\\\\F75_INV_02-03_m.csv")
d3<-read.csv("C:\\Users\\korinna\\Documents\\Docteral\\F75\\data cleaning practise code\\master_groningen_inventory\\CSV files\\\\F75_INV_07-03_m.csv")
d4<-read.csv("C:\\Users\\korinna\\Documents\\Docteral\\F75\\data cleaning practise code\\master_groningen_inventory\\CSV files\\\\F75_INV_09-03_m.csv")
d5<-read.csv("C:\\Users\\korinna\\Documents\\Docteral\\F75\\data cleaning practise code\\master_groningen_inventory\\CSV files\\\\F75_INV_07-02_k.csv")
d6<-read.csv("C:\\Users\\korinna\\Documents\\Docteral\\F75\\data cleaning practise code\\master_groningen_inventory\\CSV files\\\\F75_INV_09-02_k.csv")
d7<-read.csv("C:\\Users\\korinna\\Documents\\Docteral\\F75\\data cleaning practise code\\master_groningen_inventory\\CSV files\\\\F75_INV_15-02_k.csv")
d8<-read.csv("C:\\Users\\korinna\\Documents\\Docteral\\F75\\data cleaning practise code\\master_groningen_inventory\\CSV files\\\\F75_INV_16-02_k.csv")
d9<-read.csv("C:\\Users\\korinna\\Documents\\Docteral\\F75\\data cleaning practise code\\master_groningen_inventory\\CSV files\\\\F75_INV_17-02_k.csv")
d10<-read.csv("C:\\Users\\korinna\\Documents\\Docteral\\F75\\data cleaning practise code\\master_groningen_inventory\\CSV files\\\\F75_INV_21-02_k.csv")
d11<-read.csv("C:\\Users\\korinna\\Documents\\Docteral\\F75\\data cleaning practise code\\master_groningen_inventory\\CSV files\\\\F75_INV_23-02_k.csv")
d12<-read.csv("C:\\Users\\korinna\\Documents\\Docteral\\F75\\data cleaning practise code\\master_groningen_inventory\\CSV files\\\\F75_SAMPLES_BTRandBTSlist_Updated_m.csv")
d13<-read.csv("C:\\Users\\korinna\\Documents\\Docteral\\F75\\data cleaning practise code\\master_groningen_inventory\\CSV files\\\\F75_SAMPLES_BTRandBTSlist_Updated_leftovers_m.csv")

### NOTE:Data entries (Barcode format, info in Day column) varies between malawi and kenya:
### In Malawi docs, Original Barcode contains "t1/3" (likely denotes day of sample collection, admission=1, day3=3) at the end in addition to the subject ID code (eg. "074 t1")
### In Kenya docs, only subject ID is used (eg. "591")
### In 2 Malawi docs (02-03&09-03), both columns "Day" and "Date analyses" refer to the date where analysis was performed on the samples
### In Kenya docs, column "Day" refers to time point of sample collection (admission=0,day3=3); "Date analyses" refers to date of sample analysis


##merge Malawi docs d1:d4 into dm
#d1&d2
#check colnames 
identical(colnames(d1),colnames(d2))
# check if any subject overlaps
a<-d1$Original.Barcode
b<-d2$Original.Barcode
a[a%in%b]  
#since no subject overlaps and identical col names, combine two tables by row
dm<-rbind(d1,d2)
summary(dm)

#dm&d4
#check colnames
identical(colnames(dm),colnames(d4))
# check if any subject overlaps
a<-dm$Original.Barcode
b<-d4$Original.Barcode
a%in%b 
#since no subject overlaps and identical col names, combine two tables by row
dm<-rbind(dm,d4)
summary(dm)

#dm&d3
#check colnames
identical(colnames(dm),colnames(d3))
# check if any subject overlaps
a<-dm$Original.Barcode
b<-d3$Original.Barcode
a[a%in%b] 
#3 subjects overlaps (005 t3, 004 t1, 221 t3), check rows from these subjects
d3[d3$Original.Barcode=="005 t3",]
dm[dm$Original.Barcode=="005 t3",] #same subject ID, but different storage location and date analyses
d3[d3$Original.Barcode=="004 t1",]
dm[dm$Original.Barcode=="004 t1",] #same subject ID, but different storage location and date analyses
d3[d3$Original.Barcode=="221 t3",]
dm[dm$Original.Barcode=="221 t3",] #same subject ID, but different storage location and date analyses
#all rows with the same subject ID will be kept for record and combined to the master file
dm<-rbind(dm,d3)
summary(dm)


##merge Kenya docs d5:d11 into dk
##because the format of subect ids are different b/t kenya and malawi, if merge directly, NAs will be generated to overwrite ids of kenya.
##kenya doc d8 is an already-merged file of d5, d6, d7, d8 (ie it includes all info of tests performed on 07-02,09-02,15-02, and 16-02)
##Therefore, d8 will be merged with d9,d10, and d11

#d8&d9
#check colnames
identical(colnames(d8),colnames(d9))
# check if any subject overlaps
a<-d8$Original.Barcode
b<-d9$Original.Barcode
a[a%in%b] 
#78 subjects overlaps, 
#after checking rows of these subjects revealed that subject ID duplicates each refers to samples collected at admision(day=0) and on day 3 (day=3)  
#therefore all info are remained in the merge file
dk<-rbind(d8,d9)
summary(dk)

#dk&d10
#check colnames
identical(colnames(dk),colnames(d10))
# check if any subject overlaps
a<-dk$Original.Barcode
b<-d10$Original.Barcode
a%in%b 
#no overlaps
dk<-rbind(dk,d10)
summary(dk)

#dk&d11
#check colnames
identical(colnames(dk),colnames(d11))
# check if any subject overlaps
a<-dk$Original.Barcode
b<-d11$Original.Barcode
a%in%b 
#90 overlaps, for the same reason as above, all rows will be kept
dk<-rbind(dk,d11)
summary(dk)

#write into file
write.csv(dm,file="C:\\Users\\korinna\\Documents\\Docteral\\F75\\data cleaning practise code\\master_groningen_inventory\\merge_malawi.csv")
write.csv(dk,file="C:\\Users\\korinna\\Documents\\Docteral\\F75\\data cleaning practise code\\master_groningen_inventory\\merge_kenya.csv")


