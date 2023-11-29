#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

input_folder="./images"
output_gif="grafiek.gif"


convert -delay 100 -loop 0 "$input_folder/"*.jpg "$input_folder/$output_gif"

echo "GIF created: $output_gif"
