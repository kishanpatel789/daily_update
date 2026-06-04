#!/bin/bash

#PROJECT_FOLDER=$HOME/projects/daily_update

PROJECT_FOLDER=$(dirname $(readlink -f ${BASH_SOURCE[0]}))

# weather
$PROJECT_FOLDER/date_reminder.sh
