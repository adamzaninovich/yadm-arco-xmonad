#!/bin/python

import requests
import os

city = os.environ.get('POLYBAR_WEATHER_CITY')
api_key = os.environ.get('POLYBAR_WEATHER_API_KEY')

units = "Imperial"
unit_key = "F"
lang = "en"

if city and api_key:
    try:
        request = requests.get("http://api.openweathermap.org/data/2.5/weather?id={}&lang={}&appid={}&units={}".format(city, lang,  api_key, units))
        if request.status_code == 200:
            description = request.json()["weather"][0]["description"].capitalize()
            temperature = int(float(request.json()["main"]["temp"]))
            print("{}, {} °{}".format(description, temperature, unit_key))
        else:
            print("Error: Bad HTTP Status Code " + str(request.status_code))
    except (ValueError, IOError):
        print("No Weather Data")
else:
    print("Error: No config")
