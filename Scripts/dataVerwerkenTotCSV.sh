#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

# Output CSV file
output_csv="output.csv"

# Write CSV header
echo "Tijdstip,Locatie,Temperatuur,Vochtigheid,Dag,Windsnelheid,Windrichting,Gevoelstemperatuur,UV index" > "$output_csv"

# Process JSON files
for json_file in ../data_storage/*.json; do
    timestamp=$(jq '.location.localtime' "$json_file")
    locatie=$(jq '.location.name' "$json_file")
    temp=$(jq  '.current.temp_c' "$json_file")
    humidity=$(jq '.current.humidity' "$json_file")
    
    echo "$timestamp,$locatie,$temp,$humidity" >> "$output_csv"
done
