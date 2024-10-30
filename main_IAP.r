# We've loaded the necessary packages for you in the first cell. Please feel free to add as many cells as you like!
suppressMessages(library(dplyr)) # This line is required to check your answer correctly
options(readr.show_types = FALSE) # This line is required to check your answer correctly
library(readr)
library(readxl)
library(stringr)

# Begin coding here ...

airbnb_price = read_csv("data/airbnb_price.csv", show_col_types=FALSE)
# head(airbnb_price)
airbnb_room_type = read_xlsx("data/airbnb_room_type.xlsx")
#    head(airbnb_room_type)
# head(airbnb_room_type)
airbnb_last_review = read_tsv("data/airbnb_last_review.tsv", show_col_types=FALSE)
#   head(airbnb_last_review)

# What are the dates of the earliest and most recent reviews
class(airbnb_last_review)
a = airbnb_last_review %>% 
  mutate(last_review = as.Date(last_review, format = "%B %d %Y")) %>% 
  arrange(desc(last_review)) 

first_reviewed =a %>%  summarize(first_reviewed = min(last_review))
#irst_reviewed
last_reviewed =a %>% summarize(last_reviewed = max(last_review))
#ast_reviewed

result_review = a %>% mutate(first_reviewed, last_reviewed)


# How many of the listings are private rooms?

nb_private_rooms = airbnb_room_type %>% 
  mutate(room_type = str_to_lower(room_type)) %>% 
  filter(room_type == "private room") %>% 
  count(room_type)
nb_private_rooms = nb_private_rooms$n


# What is the average listing price for all rooms (rounded to the nearest penny)?
# head(airbnb_price)
b = airbnb_price  %>% mutate(price = str_remove(price, " dollars")) %>% mutate(price = str_to_lower(price)) %>% mutate(price = as.numeric(price))
avg_price = round(mean(b$price, na.rm = TRUE), 2)


# Combine these four values

review_dates = data.frame(first_reviewed, last_reviewed, nb_private_rooms, avg_price)
review_dates