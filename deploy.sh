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
execute_with_loading() {
    local command="$1"
    
    # Executa o comando em segundo plano
    $command &
    local pid=$!
    
    # Mostra o indicador de carregamento enquanto o comando está sendo executado
    show_loading 10
    
    # Aguarda o comando terminar
    wait $pid
}
show_loading() {
    local duration=$1
    local interval=0.1
    local end_time=$(($(date +%s) + duration))
    
    echo -n "Carregando"
    
    while [ "$(date +%s)" -lt "$end_time" ]; do
        for i in {1..3}; do
            echo -n "."
            sleep "$interval"
            echo -ne "\b"  # Remove o último ponto
        done
    done
    
    echo " Concluído!"
}
createFileOrOrAndCreateFolders() {
    local file_path="$1"

    # Verifica se o caminho foi fornecido
    if [ -z "$file_path" ]; then
        echo "Erro: Caminho do arquivo não fornecido."
        return 1
    fi

    # Extrai o diretório pai do arquivo
    local dir_path=$(dirname "$file_path")

    # Cria os diretórios pai, se não existirem
    if [ ! -d "$dir_path" ]; then
        mkdir -p "$dir_path"
    fi

    # Cria o arquivo, se não existir
    if [ ! -f "$file_path" ]; then
        echo "$2" > "$file_path"
    else
        rm "$file_path"
        createFileOrOrAndCreateFolders "$1" "$2"
    fi
}

function create_file {
    text=$2
    length=${#text}
    length=$length
    formatted_number=$(echo "$length" | awk '{printf "%\047d\n", $1}')
    echo -e "${GREEN}STATIC FILE${RESET} $1 (${formatted_number}B)";
    createFileOrOrAndCreateFolders "$1" $text 
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
rootPath=$(pwd)
#Build
echo -e "\n${BOLD}${BLUE}Building..."

for inf in frontend/*; do
    cd $inf
    if [ -f "$inf/package.json" ]; then
        execute_with_loading "npm run build"
        t="${inf//"frontend/"/""}"
        echo "⛏ - ${YELLOW} $t is builded"
    else
       echo -e "${RED}the file ${inf}/package.json not exists${RESET}"
    fi
    cd $rootPath
done

echo -e "\n${BOLD}${BLUE}Moving to public..."

#move static file for /public
for arquivo_json in frontend/*/build.json; do
    build=$(jq -r '.build' "$arquivo_json") 
    output=$(jq -r '.build.output' "$arquivo_json")
    buildLocal=$(jq -r '.build.buildLocal' "$arquivo_json")
    if [ -n $buildLocal ]; then
        output="${output//\$static/$static}"
        output="${output//\$buildId/$buildId}"
        buildLocal=${arquivo_json//"build.json"/$buildLocal}
        for file in $buildLocal/*; do
            if [ -d $buildLocal ]; then
                Text=$(cat $file)
                type=$(get_type "/"$file)
                fileout="${output//\$file/$file}"
                fileout="${fileout//\$type/$type}"
                create_file $fileout $Text 
            fi
        done
    fi
    path=$buildLocal
    rm $path"" -r;
    createFileOrOrAndCreateFolders $path"/files.info" "#$buildLocal Moved for /public "
done


echo -e "${BOLD}${GREEN}Deploy is done${RESET}";