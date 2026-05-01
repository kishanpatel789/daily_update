#!/bin/bash

cat current_weather.json | jq '.dt' | xargs -I{} date -d @{}

cat current_weather.json | jq -r '"\(.weather[0].main) - \(.weather[0].description)"'
cat current_weather.json | jq -r '"\(.main.temp) Celcius"'


