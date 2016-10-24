# AWS AMI Image Creation

## Requirements

* Install [Packer](https://www.packer.io/downloads.html)
* EC2 Key Pair (packer.pem)

## Setup
* Edit config/ansible.json
* cp config/aws.json.template config/aws.json
* EDIT config/aws.json accordingly
* EDIT ansible/config.json

## Packer validate

<pre>
packer validate amazon_ami.json
</pre>

## Build

<pre>
packer build -var-file=config/aws.json -var-file=config/ansible.json amazon_ami.json
</pre>

### Debug

<pre>
PACKER_LOG=1 PACKER_LOG_PATH=/tmp/packer.log packer build -var-file=config/aws.json -var-file=config/ansible.json amazon_ami.json
</pre>

## Test

Launch an instance using this AMI
