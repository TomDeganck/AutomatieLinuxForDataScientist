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
