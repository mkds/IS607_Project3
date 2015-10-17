library(RCurl)
library(XML)
library(dplyr)
library(stringr)

#best picture
bp_url <- "https://en.wikipedia.org/wiki/Academy_Award_for_Best_Picture#Winners_and_nominees"
bp_doc <- getURL(bp_url)
bp_tables <- readHTMLTable(bp_doc)

bp_tables <- bp_tables[9:89]
#combine all tables into one data frame
bp_data_frame <- rbind_all(bp_tables)


#film editing
edit_url <- "https://en.wikipedia.org/wiki/Academy_Award_for_Best_Film_Editing"
edit_doc <- getURL(edit_url)
p_edit_doc <- htmlParse(edit_doc)

#these movies were in lists
editing_50_89 <- xpathSApply(p_edit_doc, "//ul[position()>1]/li", fun = xmlValue)
editing_50_89 <- editing_50_89[-c(41:51)]
#editing_50_89 is a long string for each year containing all movies and editors (winner comes first)
#example: "1985 Witness—Thom Noble\nA Chorus Line—John Bloom\nOut of Africa—Fredric Steinkamp,...
#these movies were in tables
editing_rest <- xpathSApply(p_edit_doc, "//tr/td", fun = xmlValue)
editing_rest <- editing_rest[20:470]
#editing_rest is a character vector that contains year, editor, and movie all in a single column