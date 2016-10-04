# Testing
* vagrant {vbox|aws} + ansible
* packer
* docker-compose

## Requirements

* Install virtualenv
* Install [Virtual Box](https://www.virtualbox.org/wiki/Downloads)
* Install [Vagrant](http://www.vagrantup.com/downloads.html)
  - vagrant init puppetlabs/centos-7.2-64-nocm
  - Several vagrant plugins will be installed on 'vagrant up'

#### AWS
* aws_deploy.pem key (EC2 Key Pair named 'aws_deploy')
* cp config/awskeys.json.template config/awskeys.json
* EDIT config/awskeys.json accordingly

## Config Settings

### AWS

* EDIT config/awsparams.json accordingly

### VirtualBox

* EDIT config/vboxparams.json accordingly

## Setup

<pre>
mkdir VENV
virtualenv VENV
source VENV/bin/activate
pip install -r requirements.txt
</pre>

### Docker host
<pre>
vagrant up [ --provider=aws ]
</pre>
* Wait 1 minute to start services and open
