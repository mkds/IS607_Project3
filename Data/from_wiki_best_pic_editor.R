library(RCurl)
library(XML)
library(dplyr)
library(stringr)

#best picture
bp_url <- "https://en.wikipedia.org/wiki/Academy_Award_for_Best_Picture#Winners_and_nominees"
bp_doc <- getURL(bp_url)
bp_tables <- readHTMLTable(bp_doc)
bp_tables <- bp_tables[9:89]
#add year and winner column
add_year <- function(x, y){
  x <- as.data.frame(x, stringsAsFactors = FALSE)
  colnames(x) <- c("Film", "Production_Company", "Producers")
  yr <- rep(y, nrow(x))
  x$Year <- yr
  x$Best_Pic_Oscar <- c("t", rep("f", nrow(x)-1))
  return(x)
}
#combine all tables into one data frame
bp_data_frame <- data.frame(NA, NA, NA, NA, NA, stringsAsFactors = FALSE)
colnames(bp_data_frame) <- c("Film", "Production_Company", "Producers", "Year", "Best_Pic_Oscar")
y <- 1934
for(i in 1:length(bp_tables)){
  bp_data_frame <- rbind(bp_data_frame, add_year(bp_tables[i], y))
  y <- y + 1
}

#
#film editing
edit_url <- "https://en.wikipedia.org/wiki/Academy_Award_for_Best_Film_Editing"
edit_doc <- getURL(edit_url)
p_edit_doc <- htmlParse(edit_doc)

#tried to use xpath to retrieve info
#was getting tripped up on multiple editors for a movie
list_nominees <- xpathSApply(p_edit_doc, "//tr/*[contains(text(), ', ')
            or contains(text(), ' and ')
            or not(contains(text(), ' and '))
            or not(contains(text(), ', '))]", fun = xmlValue) 
#this is a list of movies, editors and some junk in one list
nominees <- list_nominees[33:495]

#I know this is not how I should do it
#but I wanted to get it done any way I could
year <- NA
film_editors <- NA
oscar_edit <- c(" ")
is_movie <- FALSE
is_winner <- FALSE
for(i in 1:length(nominees)){
  if(grepl("Editor", nominees[i])){next} #pass on bad data
  if(nominees[i] == "Year"){next} #pass on bad data
  if(nominees[i] == "Film"){next} #pass on bad data
  
  #the following is my attempt to straighten out the mess
  if(grepl("^\\d{4}" , nominees[i])){
    yr <- as.numeric(str_extract(nominees[i], "^\\d{4}"))
    is_movie <- TRUE
    is_winner <- TRUE
  } 
  else {
    if(is_movie == TRUE & is_winner == TRUE){
      year <- append(year, yr)
      oscar_edit <- append(oscar_edit, c("t"))
      film_editors <- append(film_editors, nominees[i])
      is_movie <- FALSE
      is_winner <- TRUE
    } else if (is_movie == FALSE & is_winner == TRUE){
      film_editors <- append(film_editors, nominees[i])
      is_winner <- FALSE
      is_movie <- TRUE
    } else if (is_movie == TRUE & is_winner == FALSE){
      year <- append(year, yr)
      oscar_edit <- append(oscar_edit, c("f"))
      film_editors <- append(film_editors, nominees[i])
      is_movie <- FALSE
      is_winner <- FALSE
    } else if (is_movie == FALSE & is_winner == FALSE){
      film_editors <- append(film_editors, nominees[i])
      is_movie <- TRUE
      is_winner <- FALSE
    }
  }
}

#the tables switch the order of movie/editor after the 50s-80s list
Film <- append(film_editors[seq(3, 161, 2)], film_editors[seq(162, 410, 2)])
Editors <- append(film_editors[seq(2, 160, 2)], film_editors[seq(163, length(film_editors), 2)])
edit_data_frame <- data.frame(year[-1], Film, Editors, oscar_edit[-1], stringsAsFactors = FALSE)
colnames(edit_data_frame) <- c("Year", "Film", "Editor", "Edit_Oscar")

#join the data frames
best_pic_best_edit_df <- left_join(bp_data_frame, edit_data_frame)
View(best_pic_best_edit_df)


#these movies were in lists
editing_50_89 <- xpathSApply(p_edit_doc, "//ul[position()>1]/li", fun = xmlValue)
editing_50_89 <- editing_50_89[-c(41:51)]
#editing_50_89 is a long string for each year containing all movies and editors (winner comes first)
#example: "1985 Witness—Thom Noble\nA Chorus Line—John Bloom\nOut of Africa—Fredric Steinkamp,...
edit5089_df <- (str_extract(editing_50_89[1]), "\\d{4}",
                sub(" (\\w)-", "\\1", editing_50_89[1]),
                str_extract(editing_50_89[1]), "\\d{4}", "t")
colnames(edit5089_df) <- c("Year", "Film", "Editor", "Edit_Oscar")
View(edit5089_df)