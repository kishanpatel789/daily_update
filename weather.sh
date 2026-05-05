#!/bin/bash

cat current_weather.json | jq '.dt' | xargs -I{} date -d @{}

cat current_weather.json | jq -r '"\(.weather[0].main) - \(.weather[0].description)"'
cat current_weather.json | jq -r '"\(.main.temp) Celcius"'
cat current_weather.json | jq -r '"\(.clouds.all)% cloudy"'

# check if rain.1h and snow.1h are present as keys; if so, print
