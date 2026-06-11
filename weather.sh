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
CACHE_FORECAST="$CACHE_DIR/forecast_weather.json"

if [ ! -f $CACHE_CURRENT ] || [[ ! $(find $CACHE_CURRENT -mmin -$CACHE_TTL) ]]; then
  echo "Refreshing current weather cache..."
  URL="${BASE_URL}/weather?lat=${LAT}&lon=${LON}&appid=${API_KEY}&units=${UNITS}"
  curl -so $CACHE_CURRENT $URL
fi

if [ ! -f $CACHE_FORECAST ] || [[ ! $(find $CACHE_FORECAST -mmin -$CACHE_TTL) ]]; then
  echo "Refreshing forecast weather cache..."
  URL="${BASE_URL}/forecast?lat=${LAT}&lon=${LON}&appid=${API_KEY}&units=${UNITS}&cnt=$[$NUM_DAYS*8]"
  curl -so $CACHE_FORECAST $URL
fi


# repeat cache check for forecast

# parse current weather with jq and print
# parse forecast weather with jq and print



jq '.dt' $CACHE_CURRENT | xargs -I{} date -d @{} +"%Y.%m.%d %H:%M"

echo ""

jq -r '[
  "\(.weather[0].main) - \(.weather[0].description)",
  "\(.main.temp)°C",
  "\(.clouds.all)% cloudy",
  "\(.wind.speed * 3.6 | round) km/h from \(.wind.deg) deg",
  if .rain["1h"] then "\(.rain["1h"]) mm/h rain" else empty end,
  if .snow["1h"] then "\(.snow["1h"]) mm/h snow" else empty end
] | .[]
' $CACHE_CURRENT

echo ""

#jq -r '.list[] | "\(.dt | localtime)\t\(.main.temp | round)°C"' forecast_weather.json

jq -r '
.city.timezone as $tz
| .list[] 
| "\((.dt + $tz) | strftime("%a %H:%M"))\t\(.main.temp | round)°C \(.weather[0].main) (\(.pop * 100 | round))%"
' forecast_weather.json


#cat current_weather.json | jq -r '"\(.weather[0].main) - \(.weather[0].description)"'

# cat current_weather.json | jq -r '"\(.weather[0].main) - \(.weather[0].description)\n"'
# cat current_weather.json | jq -r '"\(.main.temp) Celcius"'
# cat current_weather.json | jq -r '"\(.clouds.all)% cloudy"'
