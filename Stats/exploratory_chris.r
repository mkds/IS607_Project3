library(ggplot2)
library(tidyr)
library(dplyr)
library(tidyr)
library(stringr)
library(reshape)

#since we are interested in best picture winners, I will 
#start by wrangling/tidying the data in a way that is 
#conducive toward this goal of observations as best picture
#winners


movies <- read.csv("Data/project_view_year_numeric_CLEANED.csv", stringsAsFactors=FALSE)

#there's a space at the end of the movies column
#movies$Nominee <- str_replace(movies$Nominee, "\\s$", "")



#bp_winners <- subset(movies, movies$Category == "BEST PICTURE" & Won. == "yes")

#u_movies <- unique(movies)

bp_winners <- subset(movies, (Category == "BEST PICTURE")  & Won == "yes")
#bp_winners <- rbind(bmp_winners, bp_winners)
#merged <- merge(bp_winners, movies, by ="Nominee", all.x=TRUE, all.y=FALSE)

#categories <- unique(movies$Category)


#actor_noms <- subset(movies, Category == "ACTOR")
lead_actor <- subset(movies, Category == "ACTOR IN A LEADING ROLE")
#actor_noms <- rbind(actor_noms, lead_actor)

#actress_noms <- subset(movies, Category == "ACTRESS")
lead_actress_noms <- subset(movies, Category == "ACTRESS IN A LEADING ROLE")
#actress_noms <- rbind(actress_noms, lead_actress_noms)

cinema_noms <- subset(movies, Category == "CINEMATOGRAPHY")
directing_noms <- subset(movies, Category == "DIRECTING")

film_editing_noms <- subset(movies, Category == "FILM EDITING")
sup_actor_noms <- subset(movies, Category == "ACTOR IN A SUPPORTING ROLE")
sup_actress_noms <- subset(movies, Category == "ACTRESS IN A SUPPORTING ROLE")
costume_noms <- subset(movies, Category == "COSTUME DESIGN")
directing_noms <- subset(movies, Category == "DIRECTING")
sound_edit_noms <- subset(movies, Category == "SOUND EDITING")
sound_mix_noms <- subset(movies, Category == "SOUND MIXING")


bp_winners_frame <- merge(bp_winners, film_editing_noms, by="Nominee", all.x=TRUE, suffixes = c(".best_picture",".film_editing"))
bp_winner_since_1981 <- subset(bp_winners_frame, Year.x >= 1981)

#has every bp winner since 1981 been nominated for editing?
subset(bp_winner_since_1981, is.na(Won.y))

#no, birdman, 2014 wasn't nominated for editing,
#so quote must be before 2014.

#next steps:
#complete best picture data frame with all nominee vectors
#deal with movies that have multiple noms in a category issue
#clean up the column names
#write a function to automate linear tasks
#factor out the cleanup tasks and read in the updated file

#function(nom_vector) {
 # merge(bp_winners_frame, )
#}


#total noms since 1981
movies_81_on <- subset(movies, Year >= 1981)
#1660 total nominations

#unique_categories
unique(movies_81_on$Category)
#11 unique categories (after cleaning)

#23 of the 