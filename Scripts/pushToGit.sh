#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail


TARGET_DIRECTORY="/home/tom/AutomatieLinuxForDataScientist"

cd "$TARGET_DIRECTORY"

git pull

./Scripts/dataOphalenVanAPI.sh
./Scripts/dataVerwerkenTotCSV.sh
python ./Scripts/dataVisualiseren.py

git add .

git commit -m "Automated commit - $(date +'%Y-%m-%d %H:%M:%S')"

git push

exit $?