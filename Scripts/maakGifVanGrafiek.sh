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
