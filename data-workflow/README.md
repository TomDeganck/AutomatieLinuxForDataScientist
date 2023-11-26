# Opdracht Automation Linux For Data Scientist

## API

De API die ik gebruik is een weer API die meerder datapunten ontvangt
en de data in JSON format geeft. De code om deze API te gebruiken is:

> <<https://weatherapi-com.p.rapidapi.com/current.json?q=53.1,-0.13)>>

Het script dat ik gebruik ziet er als volgt uit:

```shell
#!/bin/bash

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

1. Eerst zet ik het pad goed waar de data in opgeslagen moet worden.
2. Daarna zet ik waar de logs moeten opgeslagen worden.
3. Dan maak ik een functie aan die met de wget de data van de API ophaalt en dat opslaat in de DATA_DIR en voeg ik ook een tijdstip toe aan het bestand.
4. Ik voer het bestand uit en de error uitvoer sla ik op in de log file.
5. Ik stop het programma met de nodige error.

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

git add .

git commit -m "Automated commit - $(date +'%Y-%m-%d %H:%M:%S')"

git push

exit $?
```

1. Eerst zet ik de directory op waar mijn git repository heb staan omda hij alle commands moet uitvoeren op die directory.
2. dan pull ik eerst de git zodanig als ik aanpassingen maak aan mijn code op mijn eigen pc dat hij die eerstaanpast en dan past uitvoer en er ook geen confilcten kunnen onstaan tussen de verschillende branches
3. Daanra voer ik het data ophalen script uit.
4. Nu stage het data bestand dat hij heeft opgehaald.
5. daarna commit ik alles met als melding dat het een automatische commit is me de datum en de tijd van de commit.
6. daarna push ik alles.
7. en tenslotte sluit ik het programma af.
