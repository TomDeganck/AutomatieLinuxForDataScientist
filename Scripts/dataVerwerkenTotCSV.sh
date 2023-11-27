#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

# Output CSV file
output_csv="output.csv"

# Write CSV header
echo "tijdStip,Locatie,Temperatuur,Vochtigheid,Dag,Windsnelheid,Windrichting,Gevoelstemperatuur,UV index" > "$output_csv"

# Process JSON files
for json_file in data_storage/*.json; do
    timestamp=$(jq -r '.timestamp' "$json_file")
    co2=$(jq -r '.co2' "$json_file")
    temp=$(jq -r '.temp' "$json_file")
    humidity=$(jq -r '.humidity' "$json_file")

    echo "$timestamp,$co2,$temp,$humidity" >> "$output_csv"
done



# Process HTML files
for html_file in path/to/your/html/files/*.html; do
    timestamp=$(grep -oP '(?<=<span class="timestamp">).*?(?=<\/span>)' "$html_file")
    co2=$(grep -oP '(?<=<span class="co2">).*?(?=<\/span>)' "$html_file")
    temp=$(grep -oP '(?<=<span class="temp">).*?(?=<\/span>)' "$html_file")
    humidity=$(grep -oP '(?<=<span class="humidity">).*?(?=<\/span>)' "$html_file")

    echo "$timestamp,$co2,$temp,$humidity" >> "$output_csv"
done
