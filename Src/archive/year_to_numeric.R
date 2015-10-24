library(stringr)

# cleans up the project_view.csv downstream-- 
# removes (numbers) from year and makes column numeric.

df = read.csv("project_view_output.csv", stringsAsFactors = FALSE)

df$Year = sapply(df$Year,function(i){
    
    i = str_replace(i,"\\(.*\\)",replacement = "")
})

df$Year = as.numeric(df$Year)

write.csv(df, "project_view_year_numeric.csv", row.names=FALSE, quote=FALSE)