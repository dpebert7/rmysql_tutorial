# David Ebert
# 25 October 2016

install.packages("RSQLite")
install.packages("sqldf")

library(RSQLite)
library(sqldf)

# Connect to and disconnect from a database ----
  db = datasetsDb()
  dbDisconnect(db)



# See tables in a connection and send a query ----
  dbListTables(db)
  dbListFields(db, "iris")
  dbReadTable(db, "iris")
  
  dbGetQuery(db, "SELECT * FROM iris WHERE Species = 'setosa'")
  class(dbGetQuery(db, "SELECT * FROM iris WHERE Species = 'setosa'"))
  
  dbRemoveTable(db, "iris") # This is quite permanent!



# Creating a database connection from an R data frame ----
  library(datasets)
  head(state.x77)
  state_df = as.data.frame(state.x77)
  state_df$Name = rownames(state.x77)
  rownames(state_df) <- c()
  
  setwd("~/Desktop")
  newdb <- dbConnect(SQLite(), dbname="test.sqlite")
  
  dbWriteTable(conn = newdb, name = "state", value = state_df, overwrite = TRUE)
  dbListTables(newdb)
  dbReadTable(newdb, "state")

  
# Check out a sqlite front end like SQLite Manager (Firefox Extension) to view data from a SQL perspective.