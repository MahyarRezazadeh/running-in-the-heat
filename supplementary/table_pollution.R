# Load required libraries
library(rvest)
library(openxlsx)

# URL of the website
url <- "https://www.iqair.com/ca/world-most-polluted-countries"

# Read the HTML from the website
web_page <- read_html(url)

# Extract tables from the webpage
tables <- html_table(web_page, fill = TRUE)

# Assuming the table you need is the first one (adjust index if necessary)
pollution_data <- tables[[1]]

# Optionally, inspect the data
print(pollution_data)

# Define the path to save the XLS file
# Update the path as per your environment
file_path <- "/Users/faragons/Dropbox/FARAGON/6. papers faragon/26 running in the heat/Mahyar/0-replication package/pollution_data.xlsx"

# Write the data frame to an XLS file
write.xlsx(pollution_data, file = file_path)

# Print success message
cat("Data has been successfully saved to", file_path)


