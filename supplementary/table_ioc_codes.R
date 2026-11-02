# Load required libraries
library(rvest)
library(openxlsx)

# URL of the website
url <- "https://en.wikipedia.org/wiki/List_of_IOC_country_codes"

# Read the HTML from the website
web_page <- read_html(url)

# Extract tables from the webpage
tables <- html_table(web_page, fill = TRUE)

# The table you need is likely the first one (adjust index if necessary)
ioc_codes <- tables[[1]]

# Optionally, inspect the data
print(ioc_codes)

# Define the path to save the XLS file
# Update the path as per your environment
file_path <- "/Users/faragons/Dropbox/FARAGON/6. papers faragon/26 running in the heat/Mahyar/0-replication package/ioc_country_codes.xlsx"

# Write the data frame to an XLS file
write.xlsx(ioc_codes, file = file_path)

# Print success message
cat("Data has been successfully saved to", file_path)
