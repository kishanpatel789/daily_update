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

if [ ! -f $CACHE_CURRENT ] || [[ ! $(find $CACHE_CURRENT -mmin -1) ]]; then
  echo "need to call api"
fi

#echo $NUM_DAYS


# echo $(pwd)
# echo $0


# if [ -z $BLAH ]; then 
  # echo "not found"
# fi

# cat current_weather.json | jq '.dt' | xargs -I{} date -d @{}

# JQ_PATTERN="\(.weather[0].main) - \(.weather[0].description)\n"
# JQ_PATTERN+="\(.main.temp) Celcius" 
# echo $JQ_PATTERN
# cat current_weather.json | jq -r $JQ_PATTERN

# cat current_weather.json | jq -r '"\(.weather[0].main) - \(.weather[0].description)\n"'
# cat current_weather.json | jq -r '"\(.main.temp) Celcius"'
# cat current_weather.json | jq -r '"\(.clouds.all)% cloudy"'
# 
# # check if rain.1h and snow.1h are present as keys; if so, print
