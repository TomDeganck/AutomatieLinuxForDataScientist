#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

# Output CSV file
output_csv="./data_storage/output.csv"

# Write CSV header
echo "tijdstip,Locatie,Temperatuur_C,Temperatuur_F,Vochtigheid,Dag,Windsnelheid_kph,Windsnelheid_mph,Windrichting,Gevoelstemperatuur_C,Gevoelstemperatuur_F,UV index" > "$output_csv"

# Process JSON files
for json_file in ./data_storage/*.json; do
	timestamp=$(jq '.location.localtime' "$json_file")
	locatie=$(jq '.location.name' "$json_file")
	temp_c=$(jq '.current.temp_c' "$json_file")
	temp_f=$(jq '.current.temp_f' "$json_file")
	humidity=$(jq '.current.humidity' "$json_file")
	isDay=$(jq '.current.is_day' "$json_file")
	windSpeed_kph=$(jq '.current.wind_kph' "$json_file")
	windSpeed_mph=$(jq '.current.wind_mph' "$json_file")
	windDirection=$(jq '.current.wind_dir' "$json_file")
	feelTemperatuur_c=$(jq '.current.feelslike_c' "$json_file")
	feelTemperatuur_f=$(jq '.current.feelslike_f' "$json_file")
	UVindx=$(jq '.current.uv' "$json_file")

	echo "$timestamp,$locatie,$temp_c,$temp_f,$humidity,$isDay,$windSpeed_kph,$windSpeed_mph,$windDirection,$feelTemperatuur_c,$feelTemperatuur_f,$UVindx" >> "$output_csv"

done

echo "Data omgezet naar CSV"
