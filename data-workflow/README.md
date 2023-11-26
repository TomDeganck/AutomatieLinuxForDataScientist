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
´´crontab´

0,30 \* \* \* \* ////AutomatieLinuxForDataScientist/Scripts/pushToGit.sh

´´´
