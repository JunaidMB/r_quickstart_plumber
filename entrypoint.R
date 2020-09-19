r <- plumber::plumb(file = "plumber.R")
r$run(port = 8000)

# Curl commands to test
## Should work
# curl -X POST --data '{"id":"123", "name":"Junaid", "token":"7DAVAHbjiM"}' "http://localhost:8000/user"  

## Should return an error for missing token
# curl -X POST --data '{"id":"123", "name":"Junaid"}' "http://localhost:8000/user" 

## Should return an error for incorrect token
# curl -X POST --data '{"id":"123", "name":"Junaid", "token":"foobar"}' "http://localhost:8000/user"