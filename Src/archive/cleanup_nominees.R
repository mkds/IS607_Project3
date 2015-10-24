library(stringr)
library(plyr)
library(tidyr)

# cleans up the MASTER.csv -- removes {text} and [text] from Nominees and adds NAs

df = read.csv("Data_All_MASTER.csv", stringsAsFactors = FALSE)

df$Nominee = sapply(df$Nominee,function(i){
    
    i = str_replace(i,"(\\{.*\\})",replacement = "")
    i = str_replace(i,"(\\[.*\\])",replacement = "")
})

df[df == ""] = NA

write.csv(df, "Data_All_MASTER_edit.csv", row.names=FALSE, quote=FALSE)


