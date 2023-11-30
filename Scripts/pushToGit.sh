#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail


TARGET_DIRECTORY="/home/tomde/AutomatieLinuxForDataScientist"

cd "$TARGET_DIRECTORY"

git pull

./Scripts/dataOphalenVanAPI.sh
./Scripts/dataVerwerkenTotCSV.sh
python Scripts/dataVisualiseren.py
./Scripts/maakGifVanGrafiek.sh

pandoc README.md -o verslag.pdf

git add .

git commit -m "Automated commit - $(date +'%Y-%m-%d %H:%M:%S')"

git push


exit $?