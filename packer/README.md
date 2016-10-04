# Virtualbox Image Creation

## Requirements

* Install [Virtual Box >= 5.0.26 ](https://www.virtualbox.org/wiki/Downloads)
* Install [Packer](https://www.packer.io/downloads.html)

## Packer validate

`packer validate vbox.json`

## Build

`packer build -var-file=config/test.json vbox.json`

### Debug

`PACKER_LOG=1 PACKER_LOG_PATH=/tmp/packer.log packer build -var-file=config/test.json vbox.json` 

## Test

vagrant box remove centos$(date +%Y%m%d)
vagrant up

## Clear Test

vagrant destroy
