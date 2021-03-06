require(tidyr)
require(dplyr)
require(knitr)
require(stringr)
require(ggplot2)


# Best Motion Picture did not start until 1944
# I have separated Best Picture/Best Motion Picture into a different data frame and then joined it by matching Category that it also won
# The frequency of Categories that matched the Best Picture is plotted
# According to the plot, 55 Best Pictures also won Directing Category
# Only 33 Best Pictures also won Film Editing

# Load Master File
academy_awards <- read.csv(file = "c:\\607_proj3\\Data_All_MASTER_edit.csv", stringsAsFactors = FALSE)
kable(head(academy_awards))

# Separate Best Picture won into different data frame
best_picture <- academy_awards %>% select(Year, Category, Nominee, Won.) %>%
                filter(Won. == "yes", 
                       Category %in% c("BEST PICTURE", "BEST MOTION PICTURE")) %>%
                arrange(Year)
kable(head(best_picture))

# Select Categories and other columns into different data frame
categories_won <- academy_awards %>% select(Year, Category, Nominee, Won.) %>%
                  filter(Won. == "yes", 
                         !(Category %in% c("BEST PICTURE", "BEST MOTION PICTURE"))) %>%
                  arrange(Year)
kable(head(categories_won))

# Join the data frames based on the Best Pictures won
category_picture_joined <- categories_won %>% inner_join(best_picture, by = "Nominee")
kable(head(category_picture_joined))

# Find the frequence and percent of each category 
category_freq <- category_picture_joined %>%  
                 group_by(Category.x) %>% 
                 summarise(count = n()) %>%
                 mutate(percent=round(count/sum(count),digits=2)) %>% arrange(desc(percent))

# How many Best Pictures also won other categories?
sum(category_freq$count)

# Plot it
ggplot(head(category_freq, n=10), aes(x=Category.x, y=count)) + geom_bar(stat = "identity")

