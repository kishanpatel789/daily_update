#!/bin/bash

set -euo pipefail

DATA_FILE=$HOME/.data/date_reminder_dates.csv

if [ ! -f $DATA_FILE ]; then
  echo "Error: Data file does not exist at '$DATA_FILE'"
  exit 1
fi

TODAY=$(date +%Y-%m-%d)
TODAY_MD=${TODAY:5}

echo "------ $TODAY ------"

while IFS=',' read d_date type person_id display_name; do
  # skip header
  if [[ $d_date == "date" ]]; then
    continue
  fi


  #echo "$person_id has $type on $d_date"
  echo ${d_date:5} is $TODAY_MD?

done < "$DATA_FILE"
