freegeoip-server
================

## Run Locally With Provising From Chef Solo ##
1. ```$ git submodule update --init --recursive```
2. Install Virtual box
3. Install Vagrant
4. Install Chef-DK
5. Install Vagrant Omnibus ```$ vagrant plugin install vagrant-omnibus```
6. Install Vagrant Berkshelf ```$ vagrant plugin install vagrant-berkshelf```
7. ```$ vagrant up```

## Create EC2 Instance With Provising From Chef Server ##
1. Setup knife.rb with correct AWS and Chef Server credentials.
2. ``` $ knife ec2 server create -i <amazon_key>
    -r "recipe[freegeoip-server]"
    --region us-east-1
    -I ami-08389d60
    -x ubuntu
    -G default
    -N <instance_name>
    -S <ec2_keychain_name>
    -E production
    -f t1.micro```
