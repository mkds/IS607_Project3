library(stringr)
library(plyr)
library(tidyr)

#read in data
edit_txt <- readLines("data/Academy_awards.txt")

#subset only the missing years
edit_txt <- edit_txt[694:728]

#instantiate a DF with raw text and identify the year lines
edit_frame <- data.frame(edit_txt, 
                         str_detect(edit_txt, "[[:digit:]]{4}"),
                         stringsAsFactors = FALSE)

colnames(edit_frame) <-  c("text", "year?")

#remove the blanks
edit_frame <- subset(edit_frame, text != "")
edit_frame <- subset(edit_frame, text != "FILM EDITING")
edit_frame[,"year"] <- NA
row.names(edit_frame) <- 1:length(edit_frame$text)

edit_frame[,"winner?"] <- "no"
year_counter <- ""

for (i in 1:length(edit_frame$text)) {
  if (edit_frame[i,"year?"] == TRUE) {
    year_counter <- edit_frame[i,"text"]
  }
  edit_frame[i,"year"] <- year_counter
  
  if (edit_frame[i,"text"] == "*\t") {
    edit_frame[i + 1,"winner?"] <- "yes"
  } 
}


best_edit <- subset(edit_frame, edit_frame$'year?' == FALSE)
best_edit <- subset(best_edit, best_edit$'text' != "*\t")
best_edit <- cbind(best_edit[1], best_edit[3:4])
best_edit[,"Additional Info"] <- NA
best_edit[,"Category"] <- "Film Editing"
best_edit <- as.data.frame(cbind( best_edit$year, best_edit$Category, best_edit$text, best_edit$'Additional Info', best_edit$'winner?'), stringsAsFactors = FALSE)

colnames(best_edit) <- c("Year", "Category", "Nominee", "Additional Info", "Won?")

split_up <- str_split(best_edit$Nominee, "\\s--\\s")


for (i in 1:length(best_edit$Nominee)) {
  best_edit$Nominee[i] <- split_up[[i]][1]
  best_edit$'Additional Info'[i] <- split_up[[i]][2]
}