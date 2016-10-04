#!/usr/bin/env bash

# Debug flags
# when one command fails, exit immediately from script
#set -e
# when piped command fails, pass the error code so echo $? returns it
#set -o pipefail
# print the commands
#set -o xtrace

# where this script resides
my_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${my_dir}/../VENV/bin/activate

function build_dockers() {
  echo "Building Images"
  docker-compose -f "${my_dir}/docker-compose.yml" build
}

build_dockers
