#!/bin/bash

set -euo pipefail

# get config
SCRIPT_DIR=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
CONFIG_FILE=$SCRIPT_DIR/.weather_config

if [ ! -f $CONFIG_FILE ]; then
  echo "Error: Config file does not exist at '$CONFIG_FILE'"
  exit 1
fi

source $CONFIG_FILE

# check cache
CACHE_DIR="$HOME/.cache/bash_scripts"

if [ ! -d $CACHE_DIR ]; then
  echo "Creating directory '$CACHE_DIR'"
  mkdir -p $CACHE_DIR
fi

CACHE_CURRENT="$CACHE_DIR/current_weather.json"

# TODO: update cache threshold to 15 minutes

# if [ ! -f $CACHE_CURRENT ] || [[ ! $(find $CACHE_CURRENT -mmin -5) ]]; then
  # echo "Refreshing current weather cache..."
  # URL="${BASE_URL}/weather?lat=${LAT}&lon=${LON}&appid=${API_KEY}&units=${UNITS}"
  # curl -so $CACHE_CURRENT $URL
# fi



# repeat cache check for forecast

# parse current weather with jq and print
# parse forecast weather with jq and print



jq '.dt' $CACHE_CURRENT | xargs -I{} date -d @{}

jq -r '"
\(.weather[0].main) - \(.weather[0].description)
\(.main.temp) Celcius
\(.clouds.all)% cloudy
"' $CACHE_CURRENT

#cat current_weather.json | jq -r '"\(.weather[0].main) - \(.weather[0].description)"'

# cat current_weather.json | jq -r '"\(.weather[0].main) - \(.weather[0].description)\n"'
# cat current_weather.json | jq -r '"\(.main.temp) Celcius"'
# cat current_weather.json | jq -r '"\(.clouds.all)% cloudy"'
# 
# # check if rain.1h and snow.1h are present as keys; if so, print
