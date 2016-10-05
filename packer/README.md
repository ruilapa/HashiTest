# Virtualbox Image Creation

## Requirements

* Install [Virtual Box >= 5.0.26 ](https://www.virtualbox.org/wiki/Downloads)
* Install [Packer](https://www.packer.io/downloads.html)

## Packer validate

<pre>
packer validate vbox.json
</pre>

## Build

<pre>
packer build -var-file=config/test.json vbox.json
</pre>

### Debug

<pre>
PACKER_LOG=1 PACKER_LOG_PATH=/tmp/packer.log packer build -var-file=config/test.json vbox.json
</pre>

## Test

<pre>
vagrant box remove centos$(date +%Y%m%d)
vagrant up
</pre>

## Clear Test

<pre>
vagrant destroy
</pre>
