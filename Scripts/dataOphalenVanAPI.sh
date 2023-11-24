#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

DATA_DIR="../data_storage"
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
