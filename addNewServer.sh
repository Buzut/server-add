#!/bin/bash

sshKeys=''
ansibleHostsPathMac='/opt/local/etc/ansible/hosts'
ansibleHostsPathLinux='/etc/ansible/hosts'

read -p 'server ip: ' serverIp
read -p 'ssh config server name: ' serverName
read -p 'Ansible group for this server: ' serverGroup

# define a random pass for root as we won't login with it anymore
newRootPass=`openssl rand -base64 32`

# config ssh & login for automatic connection via ssh key
ssh root@$serverIp /bin/bash <<ENDSSH
    # add our ssh keys to root user's authorized_keys
    cd /root
    mkdir -p .ssh
    echo "$sshKeys" >> .ssh/authorized_keys

    # configure sshd to accept only auth via keyfile
    sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' /etc/ssh/sshd_config
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    service ssh restart

    # change root password
    echo "root:$newRootPass" | chpasswd

    exit
ENDSSH

# add new server to .ssh/config
echo "
Host $serverName
HostName $serverIp
User root" >> ~/.ssh/config

# add new server into ansible (use php instead of sed for OS X compatibility)
serverGroupPhp='['$serverGroup']'
serverGroupSed='\['$serverGroup'\]'

if [[ $OSTYPE == darwin* ]]
then
    php -r 'file_put_contents($argv[3], str_replace($argv[1], "$argv[1]\n$argv[2]", file_get_contents($argv[3])));' $serverGroupPhp $serverName $ansibleHostsPathMac
else
    sed -i "s/$serverGroupSed/$serverGroupSed\n$serverName/" $ansibleHostsPathLinux
fi
