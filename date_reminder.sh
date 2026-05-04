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

output=""

while IFS="," read d_date type person_id display_name; do
  # skip header
  if [[ $d_date == "date" ]]; then
    continue
  fi


  #echo "$person_id has $type on $d_date"
  if [[ ${d_date:5} == ${TODAY:5} ]]; then
    num_years=$[ $(date +%Y) - ${d_date:0:4} ]

    if [[ -n $display_name ]]; then 
      name=${display_name//\"/}
    else
      temp=${person_id%%.*}
      name=${temp/+/ and }
    fi

    output+="$person_id - ${type^^} - $num_years\n"
    output+="Happy $type, $name! 🎉\n"
    output+="Have a great day! 😀\n\n"
  fi

done < "$DATA_FILE"

echo -e $output
