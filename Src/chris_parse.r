library(stringr)
library(plyr)
library(tidyr)

#read in data
edit_txt <- readLines("All_Academy_awards.1934-2014.txt")

#instantiate a DF with raw text and identify the year lines
edit_frame <- data.frame(edit_txt, 
                         str_detect(edit_txt, "^[0-9]{4} \\([0-9]{1,2}..\\)"),
                         str_detect(edit_txt, "(^[A-Z]{3})|\\([A-Z a-z]+\\)$"),
                         stringsAsFactors = FALSE)

colnames(edit_frame) <-  c("text", "year?", "category?")

year_counter = ""
category_counter = ""

#filter code 
for (i in 1:length(edit_frame$text)){
    if (edit_frame[i,"year?"] == TRUE) {
        year_counter <- edit_frame[i,"text"]
    }
    edit_frame[i,"year"] <- year_counter
    
    if (edit_frame[i,"text"] == "*\t") {
        edit_frame[i + 1,"winner?"] <- "yes"
    } 
    
    if (edit_frame[i, "category?"] == TRUE){
        category_counter <- edit_frame[i, "text"]
    }
    edit_frame[i,"category"] <- category_counter
}

#cleanup and filtering 
edit_frame = subset(edit_frame, text != "*\t")
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
write.csv(best_edit, "Data_All.csv", row.names=FALSE, quote=FALSE)
