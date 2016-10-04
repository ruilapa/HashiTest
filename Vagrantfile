# -*- mode: ruby -*-
# vi: set ft=ruby :
#
#
require 'json'

# Load config variables
params = JSON.parse(File.read(File.expand_path "./config/awsparams.json"))
creds = JSON.parse(File.read(File.expand_path "./config/awskeys.json"))
virtualbox = JSON.parse(File.read(File.expand_path "./config/vboxparams.json"))
infrastructure = JSON.parse(File.read(File.expand_path "./config/infrastructure.json"))

# Check Requirements
Vagrant.require_version ">= 1.8.5"

unless Vagrant.has_plugin?("vagrant-aws")
  system("vagrant plugin install vagrant-aws")
  puts "Dependency vagrant-aws installed, please try the command again."
  exit
end

unless Vagrant.has_plugin?("vagrant-cachier")
  system("vagrant plugin install vagrant-cachier")
  puts "Dependency vagrant-cachier installed, please try the command again."
  exit
end

unless Vagrant.has_plugin?("vagrant-docker-compose")
  system("vagrant plugin install vagrant-docker-compose")
  puts "Dependency vagrant-docker-compose installed, please try the command again."
  exit
end


# Workaround for mitchellh/vagrant#1867
if ARGV[1] and \
   (ARGV[1].split('=')[0] == "--provider" or ARGV[2])
   provider = (ARGV[1].split('=')[1] || ARGV[2])
else
   provider = (ENV['VAGRANT_DEFAULT_PROVIDER'] || :virtualbox).to_sym
end
puts "Detected #{provider}"

# Set Ansible variables
extra_vars = infrastructure.merge(virtualbox)

if provider == 'aws'
    extra_vars = infrastructure.merge(params).merge(creds)
end

# Setup
Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.ssh.pty = true
  config.ssh.insert_key = false
  config.vm.post_up_message = "Docker cluster is ready."

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.define "docker" do |config2|
    # Set Private IP
    # config2.vm.network "private_network", ip: virtualbox['vbox_local_ip']

    # HTTP port "mapping"
    config2.vm.network "forwarded_port", guest: 80, host: 1080
    config2.vm.network "forwarded_port", guest: 443, host: 10443

    # VirtualBox
    config2.vm.provider :virtualbox do |vb, override|
      override.vm.synced_folder ".", "/vagrant"
      override.vm.box = "puppetlabs/centos-7.2-64-nocm"
      override.vm.box_url = "puppetlabs/centos-7.2-64-nocm"
      vb.memory = virtualbox['vbox_memory']
      vb.cpus = virtualbox['vbox_cpus']
    end

    # AWS ( https://github.com/mitchellh/vagrant-aws )
    config2.vm.provider :aws do |aws, override|
      override.vm.synced_folder ".", "/vagrant", type: "rsync"
      aws.access_key_id = creds['access_key_id']
      aws.secret_access_key = creds['secret_access_key']
      aws.region = params['region']
      aws.ami = params['aws_image_id']
      aws.keypair_name = params['keypair_name']
      aws.security_groups = params['security_groups']
      aws.tags = params['tags']
      aws.instance_type = params['instance_type']
      aws.user_data = File.read("userdata.txt")

      override.vm.box = "aws-box"
      override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
      override.ssh.pty = true
      override.ssh.username = params['instance_username']
      override.ssh.private_key_path = params['keypair_name'] + ".pem"
    end

    # Fix error "sudo: sorry, you must have a tty to run sudo"
    config2.vm.provision "shell", inline: <<-SHELL
      sed -i 's/Defaults.*requiretty/#Defaults requiretty/' /etc/sudoers
    SHELL

    # Ansible - setup docker, ...
    config2.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/install.yml"
      ansible.extra_vars = extra_vars
      # ansible.verbose = "vvv"
    end

#    # Run docker
#    config2.vm.provision "docker" do |d|
#      d.pull_images "tutum/hello-world"
#      d.run "tutum/hello-world",
#        auto_assign_name: false,
#        args: "--net=host -e \"DOCKER_HOST_IP=`hostname -I | awk '{print $1;}'`\" -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/bin/docker -v /sys/fs/cgroup:/sys/fs/cgroup"
#    end

    # Docker-compose - Alternative method
    config2.vm.provision "docker_compose", yml: "/vagrant/dockers/docker-compose.yml", rebuild: true, run: "always"
  end
end
