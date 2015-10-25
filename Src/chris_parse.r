library(stringr)
library(plyr)
library(tidyr)

################ CHRIS_PARSE ########################
# This is the main parsing script originally written by Chris on 10/17

# As of 10/24 it has been refactored to output a CSV from the 
# file rawdata_from_awardsDatabase.txt

# Place the above text file in your working directory and run the script 
# to get clean csv output for downstream analysis.

# Any further cleaning/filtering/subsetting for analysis should be done 
# in new scripts using the csv output from this chris_parse.r script
######################################################


#read in data
edit_txt <- readLines("rawdata_from_awardsDatabase.txt")

#instantiate a DF with raw text and identify the year lines
edit_frame <- data.frame(edit_txt, 
                         str_detect(edit_txt, "^[0-9]{4} \\([0-9]{1,2}..\\)"),
                         str_detect(edit_txt, "(^[A-Z]{3})|\\([A-Z a-z]+\\)$"),
                         stringsAsFactors = FALSE)

colnames(edit_frame) <-  c("text", "year?", "category?")

# drop prior to 1934 
edit_frame = edit_frame[1493:length(rownames(edit_frame)),]

#drop blanks
edit_frame = edit_frame[!edit_frame$text == "",]


year_counter = ""
category_counter = ""

#filter code 
for (i in 1:length(edit_frame$text)){
    if (edit_frame[i,"year?"] == TRUE) {
        year_counter <- edit_frame[i,"text"]
    }
    edit_frame[i,"year"] <- year_counter
    
    if (str_detect(edit_frame[i,"text"], "^\\*")) {
        edit_frame[i,"winner?"] <- "yes"
        edit_frame[i,"text"] = str_extract(edit_frame[i,"text"], "([^\\*]+)")
    } 
    
    if (edit_frame[i, "category?"] == TRUE){
        category_counter <- edit_frame[i, "text"]
    }
    edit_frame[i,"category"] <- category_counter
}

#cleanup and filtering 
edit_frame1 = edit_frame[edit_frame$"year?" == FALSE, ]   # new edit frame in case of disaster...
edit_frame1 = subset(edit_frame1, text != category)
edit_frame1 = subset(edit_frame1, text != "")
edit_frame1$`year?` = NULL
edit_frame1$`category?` = NULL
edit_frame1[,"Additional Info"] = NA
edit_frame1$`winner?`[which(is.na(edit_frame1$`winner?`))] <- "no"
#remove the blanks
best_edit <- data.frame(edit_frame1$year, 
                        edit_frame1$category, 
                        edit_frame1$text, 
                        edit_frame1$'Additional Info', 
                        edit_frame1$'winner?', stringsAsFactors = FALSE)


colnames(best_edit) <- c("Year", "Category", "Nominee", "Additional Info", "Won?")

split_up <- str_split(best_edit$Nominee, "\\s--\\s")

for (i in 1:length(best_edit$Nominee)) {
  if(str_detect(best_edit$Category[i],"(ACTOR|ACTRESS)"))
  {
    best_edit$Nominee[i] <- split_up[[i]][2]
    best_edit$'Additional Info'[i] <- split_up[[i]][1]
  }
  else
  {
    best_edit$Nominee[i] <- split_up[[i]][1]
    best_edit$'Additional Info'[i] <- split_up[[i]][2]
  }
}
# replace , with ;
best_edit$`Additional Info` <- str_replace_all(best_edit$`Additional Info`,",",";")
best_edit$Nominee <- str_replace_all(best_edit$Nominee,",",";")
best_edit$Category <- str_replace_all(best_edit$Category,",",";")


## Added from cleanup_nominees.R -- that script is now deprecated

best_edit$Nominee = sapply(best_edit$Nominee,function(i){
    
    i = str_replace(i,"(\\{.*\\})",replacement = "")
    i = str_replace(i,"(\\[.*\\])",replacement = "")
})

## Added from year_to_numeric.r -- that script is now deprecated 

best_edit$Year = sapply(best_edit$Year,function(i){
    
    i = str_replace(i,"\\(.*\\)",replacement = "")
})

best_edit$Year = as.numeric(best_edit$Year)
best_edit[best_edit == ""] = NA


#--FINAL OUTPUT--
write.csv(best_edit, "Data_All_MASTER.csv", row.names=FALSE, quote=FALSE)
