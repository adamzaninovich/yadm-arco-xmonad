#!/bin/bash

source $HOME/.config/bash/private

units="Imperial"
unit_key="F"
lang="en"

city=$POLYBAR_WEATHER_CITY
api_key=$POLYBAR_WEATHER_API_KEY

if [ -n "${city:-}" ] && [ -n "${api_key:-}" ]; then
  url="http://api.openweathermap.org/data/2.5/weather?id=${city}&lang=${lang}&appid=${api_key}&units=${units}"
  response=$(curl --silent --write-out "HTTPSTATUS:%{http_code}" "$url")
  body=$(echo "$response" | sed -e 's/HTTPSTATUS\:.*//g')
  code=$(echo "$response" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
  if [ "${code:-0}" -eq 200 ]; then
    description=$(echo "$body" | jq '.weather[0].description' | tr -d '"')
    description="${description^}"
    temp=$(echo "$body" | jq '.main.temp')
    temp=${temp%.*}
    echo "${description}, ${temp} °${unit_key}"
  else
    echo "Error: Bad Response"
  fi
else
  echo "Error: No Config"
fi
