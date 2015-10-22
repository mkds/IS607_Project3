
# Load libraries
library(stringr)
library(dplyr)
library(tidyr)

########### Chris's parsing text file ############
#read in data
edit_txt <- readLines("https://raw.githubusercontent.com/mkds/IS607_Project3/gh-pages/Data/Raw/All_Academy_awards.1934-2014.txt")


#instantiate a DF with raw text and identify the year lines
edit_frame <- data.frame(edit_txt, 
                         str_detect(edit_txt, "^[0-9]{4} \\([0-9]{1,2}..\\)"),
                         str_detect(edit_txt, "(^[A-Z]{3})|\\([A-Z a-z]+\\)$"),
                         stringsAsFactors = FALSE)

#set column names
colnames(edit_frame) <-  c("text", "year?", "category?")

year_counter = ""
category_counter = ""

# filter code 
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

colnames(best_edit) <- c("Year", "Category", "Nominee", "Additional Info", "Won")

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

############## John DeBlase's code for cleanup #########################
best_edit$Nominee = sapply(best_edit$Nominee,function(i){
  
  i = str_replace(i,"(\\{.*\\})",replacement = "")
  i = str_replace(i,"(\\[.*\\])",replacement = "")
})

best_edit[best_edit == ""] = NA

######################################################################

##################### Puneet - further clean up ######################
# Read csv file as it contains the Best Picture values
read_csv <- read.csv("https://raw.githubusercontent.com/mkds/IS607_Project3/gh-pages/Data/Raw/academy_awards.csv")

# Select the columns needed and set names
awards_csv <- read_csv %>% select(Year, Category, Nominee, Additional.Info, Won.)
colnames(awards_csv) <- c("Year", "Category", "Nominee", "Additional Info", "Won")

# Get the 2010-2014 data from best_edit data frame
best_edit_last_4_years <- best_edit[grep("^201[1-4].*",best_edit$Year),]

# Combine csv and text file data
awards_combined <- rbind(best_edit_last_4_years, awards_csv) 


# Separate out Year, Category and Nominee into 2 columns
awards <- awards_combined %>%
          filter(Won %in% c("YES","NO","yes","no")) %>%
          separate(Year, c("Year", "AwardSeason"), sep = " \\(") %>%  # separate year from the number
          separate(Category, c("Category", "CategoryType"), sep = " -- | \\(| IN A ") # separate Category and its description

# More cleanup
awards$AwardSeason <- str_replace(awards$AwardSeason, "\\w\\w\\)", "")
awards$CategoryType <- str_replace(awards$CategoryType, "\\)", "")
awards$Year <- str_replace(awards$Year, "/.*", "")
awards$Nominee <- str_replace(awards$Nominee, "^To\\s(.*?)( for| of|, as).*", "\\1")
awards$Nominee <- str_replace(awards$Nominee, " -- .*|\\[NOTE.*", "")

# Switch Category and Nominees to uppercase
awards$Category <- toupper(awards$Category)
awards$Nominee <- toupper(awards$Nominee)
awards$Won <- toupper(awards$Won)

###############################################################

# Write Master file
write.csv(awards, "Data_All_MASTER_edit_10_20.csv", row.names=FALSE, quote = TRUE)