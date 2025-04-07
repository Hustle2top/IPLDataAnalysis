
import pandas as pd
import requests

# URL of the webpage
Url = "https://www.espncricinfo.com/records/trophy/batting-most-runs-series/indian-premier-league-117"

# Headers to mimic a real browser
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
}

# Fetching the webpage with headers
response = requests.get(Url, headers=headers)

# Checking if request was successful
if response.status_code == 200:
    tables = pd.read_html(response.text)

# Saving the table to Excel
    with pd.ExcelWriter("scraped_data.xlsx") as writer:
        for i, table in enumerate(tables):
            table.to_excel(writer, sheet_name=f"Table_{i+1}", index=False)
    
    print("Data saved to 'scraped_data.xlsx' successfully!")
else:
    print(f"Failed to fetch page. Status code: {response.status_code}")









