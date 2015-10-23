library(stringr)

movies <- read.csv("Data/project_view_year_numeric.csv", stringsAsFactors=FALSE)

#there's a space at the end of the movies column
movies$Nominee <- str_replace(movies$Nominee, "\\s$", "")

#combine duplicate categories
movies$Category <- str_replace(movies$Category, "^ACTOR$", "ACTOR IN A LEADING ROLE")
movies$Category <- str_replace(movies$Category, "^ACTRESS$", "ACTRESS IN A LEADING ROLE")
movies$Category <- str_replace(movies$Category, "^BEST MOTION PICTURE$", "BEST PICTURE")

write.csv(movies, "Data/project_view_year_numeric_CLEANED.csv", row.names = FALSE)
