#!/bin/bash

#decore vars
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
RESET='\033[0m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
REVERSE='\033[7m'

#buildId=$(tr -dc A-Ma-z0-9\_\- </dev/urandom | head -c 16)
buildId="jzcfw3ks-EJ"

echo -e "${BOLD}${GREEN}Deploy starting${RESET}";
echo -e "${YELLOW}"

static=$(pwd)"/public/s"
echo $static

function function_name {
    echo -e "${GREEN}STATIC FILE${RESET} $1"
    echo -e "${YELLOW}"
}
get_type() {
    local file="$1"  # Get the file name argument
    local extension="${file##*.}"  # Extract the file extension
    case "$extension" in
        "css") echo "cssbin" ;;
        "js") echo "jsbin" ;;
        "svg") echo "svgbin" ;;
        "outer") echo "outersbin" ;;
        *) echo "unknown" ;;  # Default case if the extension does not match
    esac
}
#Build




#move static file for /public
for arquivo_json in frontend/*/build.json; do
    build=$(jq -r '.build' "$arquivo_json") 
    output=$(jq -r '.build.output' "$arquivo_json")
    buildLocal=$(jq -r '.build.buildLocal' "$arquivo_json")
    if [ $buildLocal ]; then
        output="${output//\$static/$static}"
        output="${output//\$buildId/$buildId}"
        buildLocal=${arquivo_json//"build.json"/$buildLocal}
        for file in $buildLocal/*; do
            type=$(get_type "/"$file)
            fileout="${output//\$file/$file}"
            fileout="${fileout//\$type/$type}"

            echo -e "${BOLD}$file -> $fileout"
        done
    fi
done


echo -e "${BOLD}${GREEN}Deploy is done${RESET}";