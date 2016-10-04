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

function launch_machine() {
  VM_STATUS=$(vagrant status --machine-readable | grep ',state,' | cut -d',' -f4)
  echo "VM is $VM_STATUS"
  if [ "$VM_STATUS" != "running" ]; then
    vagrant up
  fi
}

function restart_dockers() {
  echo "Stopping Old Dockers"
  docker-compose -f "${my_dir}/docker-compose.yml" down

  echo "Launching New Dockers"
  docker-compose -f "${my_dir}/docker-compose.yml" up -d
}

launch_machine

restart_dockers
