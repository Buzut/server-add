# server-add
Smart script to automatically add a new server to ssh config file, Ansible hosts file and configure remote server ssh to connect with ssh-keys and refuse password auth. The script will also set a random pass for root as the provider often send default password over email. 

Just put your public key string in `sshKeys`, give the script execution right by doing a `chmod +x addNewServer.sh` and you're good to go.

Launch it with `./addNewServer.sh`. It's that simple!
