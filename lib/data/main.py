from flask import Flask
from flask import request
import requests
from bs4 import BeautifulSoup
import re

app = Flask(__name__)

@app.route("/data")
def get_data():
    ''' Get data from url endpoint '''
    try:
        url = request.args.get('url')

        print(url)

        response = requests.get(url=url)

        soup = BeautifulSoup(response.text, 'html.parser') #  parse returned content

        current_total = soup.select(".hrt-disp-inline")
        number_of_donations = soup.select(".hrt-text-gray-dark")
        title = soup.select(".p-campaign-header h1")
        goal = soup.select(".hrt-text-body-sm")
        hero_img = soup.select(".campaign-hero_image__J8h8b img")

        current_total = current_total[0].text # current total

        number_of_donations = number_of_donations[0].text

        title = title[0].text

        pattern = r'\b\d{1,3}(?:,\d{3})*(?:\.\d+)?\b' # regex pattern to match and return numbers within target goal

        goal = re.search(pattern=pattern,string=goal[0].text)
        
        currency = current_total[0]

        current_total = current_total[1:]

        hero_img = hero_img[0].get('src')

        domain,identifier = url.split('/f/') # splits endpoint to domain and unique identifier

        

        return {
            "message":"Succesfull fetch",
            "data":{
                "current_total":f'{current_total} {currencyMap[currency]}', 
                "donaters": number_of_donations,
                "title":title,
                "goal":f'{goal.group()} {currencyMap[currency]}',
                "hero":hero_img,
                "identifer":identifier
            },
            "status":200
        }

    except:
        ''' triggered on exception within try block '''
        return {
            "data":{},
            "message":"Error fetching data",
            "status":400
        }


currencyMap = {
    "£":"GBP",
    "$":"USD"
}