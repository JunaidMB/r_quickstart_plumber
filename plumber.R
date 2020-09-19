library(plumber)
library(RPostgres)
library(DBI)
library(dplyr)
library(lubridate)

# Obtain database credentials
source("connect_to_db.R")

# Token table
## Establish connections to a database containing valid tokens
con <- dbConnect(RPostgres::Postgres(),
                 dbname = dbname, 
                 host = host,
                 port = port, # or any other port specified by your DBA
                 user = user,
                 password = password)

Tokens <- dbReadTable(conn = con, name = 'Tokens')

#* @filter checkAuth
#* @serializer unboxedJSON
function(req, res) {
  
  user_submitted_token <- fromJSON(req$postBody)$token
  
if (is_null(user_submitted_token)) {
    
  res$status <- 401 # Unauthorized
  #list(error="Authentication required")
    
  return(list(message = "Please include a token in message body"))
  
    } else {
    
    plumber::forward()
  
    }
}


#* @filter checkToken
#* @serializer unboxedJSON
function(req, res) {
  
  user_submitted_token <- fromJSON(req$postBody)$token
  
  if (!(user_submitted_token %in% Tokens$tokens)) {
    
    res$status <- 401 # Unauthorized
    #list(error="Authentication required")
    
    return(list(message = "Incorrect token"))
    
  } else {
    
    plumber::forward()
    
  }
}



#* @filter appendsurname
function(req) {
  forename <- jsonlite::fromJSON(req$postBody)$name
  
  # Change request body
  newpostBody <- jsonlite::fromJSON(req$postBody)
  
  newpostBody$full_name <- stringr::str_c(forename, 'Butt', sep = " ")
  newpostBody$occupation <- "Data Scientist"
  newpostBody$employer <- "IBM"
  newpostBody$previous_employer <- "Pusher"
  
  req$postBody <- jsonlite::toJSON(newpostBody)
  
  plumber::forward()
}


#* @post /user
#* @serializer unboxedJSON
function(req) {
  
  
    list(
      id = jsonlite::fromJSON(req$postBody)$id,
      name = jsonlite::fromJSON(req$postBody)$name,
      full_name = fromJSON(req$postBody)$full_name,
      occupation = fromJSON(req$postBody)$occupation,
      employer = fromJSON(req$postBody)$employer,
      previous_employer = fromJSON(req$postBody)$previous_employer,
      body = jsonlite::fromJSON(req$postBody),
      message = "filters have worked"
    )

}



  

