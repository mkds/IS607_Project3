#Loading the packages

#install.packages("RSelenium")
#install.packages("rvest")

#install firefox browser

library(XML)
library(RCurl)
library(RSelenium)
library(rvest)
checkForServer() # download Selenium Server, if there is no server

# start Selenium Server
startServer()  

# instantiates a new driver
thebrowser <- remoteDriver()

# open connection
thebrowser$open()

#Load the page and process it
thebrowser$navigate("http://awardsdatabase.oscars.org/ampas_awards/BasicSearch")

#Define our search criteria
#We are interested in the records from 1934
box1 <- thebrowser$findElement(using = 'name', "BSFromYear")
box1$sendKeysToElement(list("1927")) 


#We will like to have the data from the first oscars to the last one
box2 <- thebrowser$findElement(using = 'name', "BSToYear")
box2$sendKeysToElement(list("2014")) 


# We are interested in all the categories
box3 <- thebrowser$findElement(using = 'name', "BSCategory")
box3$sendKeysToElement(list("All")) 

#The results should be displayed by category and chronogically
box4 <- thebrowser$findElement(using = 'name', "displayType")
box4$sendKeysToElement(list("1")) 

#thebrowser$ExecuteScript(paste("scroll(100,1000);"))

#After specifying our searching criteria, we have to on Search
thebrowser$findElement(using = "xpath","//input[@value = 'Search']")$clickElement()

page_source<-thebrowser$getPageSource() #we get the source of the page in HTML

#We parse the source
rawdata<-read_html(page_source[[1]]) %>% html_nodes("dl") %>%html_text()

str(rawdata)
write.table(rawdata, file = "rawdata_from_awardsDatabase.txt")
```