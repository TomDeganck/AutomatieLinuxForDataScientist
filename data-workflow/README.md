# Opdracht Automation Linux For Data Scientist

## Data Ophalen

Voor de API heb ik een weer API gekozen die meerdere variabelen terug geeft in json formaat.

> <<https://weatherapi-com.p.rapidapi.com/current.json?q=53.1,-0.13)>>

Om de data van die API te halen en op te slaan heb ik een [shell script](#script-voor-data-op-te-halen-van-api) geschreven.
Die shell script werkt als volgt:

1. Het pad naar de opslagplaats declareren.
2. Een functie schrijven om het excate tijdstip te krijgen.
3. Een functie schrijven om de data op te halen.
   1. voert het wget commando uit.
   2. zet de methode op ophalen van data.
   3. stel de headers in met de juiste keys om de data binnen te krijgen.
   4. instellen waar de data moet opgeslagen worden met het juiste tijdstip.
   5. van welke site hij de data moet halen.
4. Ik sla de error uitvoer op in een log file genaam [weer.log](/data_storage/weer.log).
5. Ik stop het programma met de nodige melding of het geslaagd is.

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

Voor het verwerken van de rauwe data naar de nodige data punten heb ik gedaan in een [shell script](#script-voor-jsons-te-verwerken-tot-csv).

Deze werkt als volgt:

1. Ik stel de locatie in waar de output CSV data moet in opgeslagen worden.
2. Ik echo de header van het [CSV bestand](/data_storage/output.csv) met de nodige variabele namen.
3. Ik gebruik een for loop die in de directory "/data_storage/" elk .json bestand afgaat.
4. Ik maak variabelen aan en haal de juiste waarden uit de json file met het commando `jq`.
5. Ik echo elke variable op de juiste plek in het [CSV bestand](/data_storage/output.csv).

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

Om de CSV data te verwerken tot een handige grafiek heb ik een [python programma](#python-progamma-om-data-te-visualiseren) geschreven.
Dit programma werkt als volgt:

1. Import eerst alle nodige library's.
2. Het pad instellen waar het [CSV bestand](/data_storage/output.csv) is opgeslagen.
3. Lees het [CSV bestand](/data_storage/output.csv) in.
4. Voeg een niewe kolom toe aan het [CSV bestand](/data_storage/output.csv) waar de tijdstippen in zijn geherformateert naar een meer leesbaar formaat.
5. Maak een grafiek aan.
6. Map alle data van het [CSV bestand](/data_storage/output.csv) met de juist tijdstip.
7. Voeg de juist namen en labels toe aan de grafiek.
8. Hernoem de oude grafiek met een tijdstip
9. Sla de grafiek op als [dataGrafiek.png](/images/dataGrafiek.png)

### Python progamma om data te visualiseren

```python
import time
from matplotlib.patches import Rectangle
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib as m
import numpy as np
import os
import pathlib

path = os.getcwd()
data = pd.read_csv(path + "/data_storage/output.csv")

data['Tijdstip'] = pd.to_datetime(data['tijdstip'], format='%Y-%m-%d %H:%M')

plt.figure(figsize=(12, 6))
plt.plot(data['Tijdstip'], data['Temperatuur_C'], label='Temperature (°C)')
plt.plot(data['Tijdstip'], data['Gevoelstemperatuur_C'], label='Touch Temperature (°C)')
plt.plot(data['Tijdstip'], data['Vochtigheid'], label='Vochtigheid')
plt.plot(data['Tijdstip'], data['Windsnelheid_kph'], label='Windsnelheid (Km/H)')

plt.title('Temperature Evolution Over Time')
plt.xlabel('Time')
plt.ylabel('Temperature (°C)')
plt.legend()
plt.grid(True)

try:
    os.rename(f'{path}/images/dataGrafiek.png',f'{path}/images/{time.time()}dataGrafiek.png')
except:
    print("niet kunnen hernoemen")
plt.savefig(f'{path}/images/dataGrafiek.png')


```

## .png's verwerken tot een gif

Als extra heb ik ook een [script](#script-voor-gif) geschreven dat van alle opgeslagen grafieken een gif maakt zodat je het verloopt van de metingen kan zien.
Het [script](#script-voor-gif) werkt als volgt:

1. Ik de directory waar de foto's gevonden kunnen worden en waar ook de GIF opgeslagen zal worden.
2. Ik stel de naam in van de GIF
3. Ik verander de working directory naar de directory van de foto's omdat alle commando's daar moeten worden uitgevoerd.
4. Ik gebruik ImageMagick om de alle foto's in te lezen en om te zetten naar een GIF met telkens een tijd tussen de twee foto's van 20ms.
5. Ik verander de working directory terug naar de algemene.
6. Ik print in de terminal dat ik de GIF heb aangemaakt.

### Script voor GIF

```shell
#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

input_folder="./images"
output_gif="grafiek.gif"

cd "$input_folder"

convert -delay 20 -loop 0 *.png "$output_gif"

cd .
echo "GIF created: $output_gif"

```

## Automatisatie van procces

voor het automatiseren van het ophalen van de data. Gebruik ik [crontab](#crontab-voor-automatisatie), een raspberry Pi en een [shell script](#script-voor-automatisatie)

De automatisatie werkt als volgt:

1. De raspberry Pi heeft een lopende [crontab](#crontab-voor-automatisatie) die elk half uur wordt uitgevoerd.
   1. In de crontab stel ik MAILTO gelijk aan niks omdat ik anders een error kreeg.
   2. Dan stel ik in dat hij elk uur op de 0<sup>e</sup> en de 30<sup>e</sup> het script [pushToGit](#script-voor-automatisatie) moet uitvoeren.
2. In het [pushToGit](#script-voor-automatisatie) script stel ik het doel directory in als de home directory van de git
3. Ik schakel naar die directory.
4. Ik pull alle data van binnen zodat er later geen confilcten kunnen onstaan.
5. Ik voer het [script](#script-voor-data-op-te-halen-van-api) uit om data op te halen.
6. Ik voer het [script](#script-voor-jsons-te-verwerken-tot-csv) uit om de data om te zetten naar een CSV.
7. Ik voer het [python programma](#python-progamma-om-data-te-visualiseren) uit voor het visualiseren van de data.
8. Ik voer het script uit om can alle gemaakte png's een gif the maken.
9. Ik zorg dat alle veranderingen gestaged worden.
10. Ik zorg dat alle veranderingen gecommit worden met als melding het tijdstip van de commit.
11. Ik push alles commits naar de main branch.
12. Ik sluit het programma af met melding of het gelukt is of niet.

### Crontab voor automatisatie

```shell
MAILTO=""
0,30 * * * * /pad/van/root/naar/repository/AutomatieLinuxForDataScientist/Scripts/pushToGit.sh

```

### Script voor automatisatie

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
./Scripts/maakGifVanGrafiek.sh

git add .

git commit -m "Automated commit - $(date +'%Y-%m-%d %H:%M:%S')"

git push

exit $?
```
