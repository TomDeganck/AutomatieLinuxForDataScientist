# Opdracht Automation Linux For Data Scientist

## Data Ophalen

Voor de API heb ik een weer API gekozen die vanalle variabelen terug geeft in json formaat

> <<https://weatherapi-com.p.rapidapi.com/current.json?q=53.1,-0.13)>>

Om de data van die API te halen en op te slaan heb ik een [shell script](#script-voor-data-op-te-halen-van-api) geschreven.
Die shell script werkt als volgt:

1. Het pad naar de opslagplaats declareren
2. Een functie schrijven om het excate tijdstip te krijgen
3. Een functie schrijven om de data op te halen
   1. voert het wget commando uit
   2. zet de methode op ophalen van data
   3. stel de headers in met de juiste keys om de data binnen te krijgen
   4. instellen waar de data moet opgeslagen worden met het juiste tijdstip
   5. van welke site hij de data moet halen
4. Ik sla de error uitvoer op in een log file genaam [weer.log](/data_storage/weer.log)
5. Ik stop het programma met de nodige melding of het geslaagd is

### Script voor data op te halen van API

```shell
#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

DATA_DIR="/home/tom/AutomatieLinuxForDataScientist/data_storage"
LOG_FILE="$DATA_DIR/weer.log"

get_timestamp() {
  date +"%Y%m%d-%H%M%S"
}

# Functie om data op te halen en op te slaan
download_and_save_data() {
  # Wget-commando om de gegevens op te halen
  wget --quiet \
    --method GET \
    --header 'X-RapidAPI-Key: 22d0e35350mshc95784da2f4ad35p154b05jsnfb511fedbf6d' \
    --header 'X-RapidAPI-Host: weatherapi-com.p.rapidapi.com' \
    --output-document "$DATA_DIR/data-$(get_timestamp).json" \
    'https://weatherapi-com.p.rapidapi.com/current.json?q=53.1%2C-0.13'
}

# Uitvoeren van de download en opslaan van data
download_and_save_data >> "$LOG_FILE" 2>&1

exit $?

```

## Data verwerken tot CSV

Voor het verwerken van de rauwe data naar de nodige data punten heb ik gedaan in een [shell script](#script-voor-jsons-te-verwerken-tot-csv)

Deze werkt als volgt:

1. Ik stel de locatie in waar de output CSV data moet in opgeslagen worden
2. Ik echo de header van het [CSV bestand](/data_storage/output.csv) met de nodige variabele namen.
3. Ik gebruik een for loop die in de directory "/data_storage/" elk .json bestand afgaat
4. Ik maak variabelen aan en haal de juiste waarden uit de json file met het commando jq
5. Ik echo elke variable op de juiste plek in het [CSV bestand](/data_storage/output.csv)

### Script voor jsons te verwerken tot CSV

```shell
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

```

## CSV verwerken tot een grafiek

Om de CSV data te verwerken tot een handige grafiek heb ik een python programma geschreven.
Deze werkt als volgt:

```python

```

## Automatisatie van data

voor het automatiseren van het ophalen van de data heb ik crontab gebruikt en een raspberry Pi
in de crontab heb ik volgende code staan

in de raspberry pi heb ik dit ingesteld als crontab

```shell
MAILTO=""
0,30 \* \* \* \* /pad/van/root/naar/repository/AutomatieLinuxForDataScientist/Scripts/pushToGit.sh

```

de reden waarom ik het script pushToGit gebruik is omdat ik elke keer als hij data ophaalt dat direct in mijn git reposetory zet en niet telkens manueel moet pushen

pushToGit.sh ziet er als volgt uit:

```shell
#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail


TARGET_DIRECTORY="/home/tom/AutomatieLinuxForDataScientist"

cd "$TARGET_DIRECTORY"

git pull

./Scripts/dataOphalenVanAPI.sh
./Scripts/dataVerwerkenTotCSV.sh
python Scripts/dataVisualiseren.py

git add .

git commit -m "Automated commit - $(date +'%Y-%m-%d %H:%M:%S')"

git push

exit $?
```

1. Eerst zet ik de directory op waar mijn git repository heb staan omda hij alle commands moet uitvoeren op die directory.
2. dan pull ik eerst de git zodanig als ik aanpassingen maak aan mijn code op mijn eigen pc dat hij die eerstaanpast en dan past uitvoer en er ook geen confilcten kunnen onstaan tussen de verschillende branches
3. Daanra voer ik het data ophalen [script](#script-voor-data-op-te-halen-van-api-dataophalen) uit.
4. hierna voer ik het [script](#dataNaarCSV) uit om de rauwe jsons te verwerken naar een CSV bestand.
5. Het laatste script dat ik uitvoer is hetgenen om de CSV om te zetten naar een grafiek en daarvan een .png op te slaan
6. Nu stage het data bestand dat hij heeft opgehaald.
7. daarna commit ik alles met als melding dat het een automatische commit is me de datum en de tijd van de commit.
8. daarna push ik alles.
9. en tenslotte sluit ik het programma af.
