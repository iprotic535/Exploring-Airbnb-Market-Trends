## Required Libraries

First, we load the necessary libraries for data manipulation, reading files, and string manipulation.
```r
suppressMessages(library(dplyr)) # Required for data manipulation
options(readr.show_types = FALSE) # Required for data reading
library(readr) # For reading CSV and TSV files
library(readxl) # For reading Excel files
library(stringr) # For string manipulation
```
## Data Loading

Next, we load the datasets containing information on Airbnb listings in New York City.
```r
# Load data
airbnb_price = read_csv("data/airbnb_price.csv", show_col_types=FALSE)
airbnb_room_type = read_xlsx("data/airbnb_room_type.xlsx")
airbnb_last_review = read_tsv("data/airbnb_last_review.tsv", show_col_types=FALSE)
```

## Data Analysis

### 1. Review Dates

To find the dates of the earliest and most recent reviews, we process the `last_review` column in the dataset.
```r
# Convert last_review to Date format and arrange
a = airbnb_last_review %>% 
  mutate(last_review = as.Date(last_review, format = "%B %d %Y")) %>% 
  arrange(desc(last_review)) 

first_reviewed = a %>% summarize(first_reviewed = min(last_review))
last_reviewed = a %>% summarize(last_reviewed = max(last_review))
```

### 2. Count of Private Rooms

Next, we count how many listings are classified as private rooms to understand the availability of this room type.
```r
# Count private rooms
nb_private_rooms = airbnb_room_type %>% 
  mutate(room_type = str_to_lower(room_type)) %>% 
  filter(room_type == "private room") %>% 
  count(room_type)

nb_private_rooms = nb_private_rooms$n
```

### 3. Average Listing Price

We calculate the average listing price for all rooms, rounded to the nearest penny, to provide insights into the pricing of Airbnb listings.
```r
# Calculate average price
b = airbnb_price %>% 
  mutate(price = str_remove(price, " dollars")) %>% 
  mutate(price = str_to_lower(price)) %>% 
  mutate(price = as.numeric(price))

avg_price = round(mean(b$price, na.rm = TRUE), 2)

```
### 4. Combine Results

Finally, we compile all the findings into a single data frame for a comprehensive overview of the data.
```r
# Combine results
review_dates = data.frame(first_reviewed, last_reviewed, nb_private_rooms, avg_price)
print(review_dates)

```
## Results

The final results of the analysis are as follows:

- **First Reviewed:** `first_reviewed` 2019-01-01
- **Last Reviewed:** `last_reviewed` 2019-07-09
- **Number of Private Rooms:** `nb_private_rooms` 11356
- **Average Price:** `avg_price` 141.78
