# server-add
Smart script to automatically add a new server to ssh config file, Ansible hosts file and configure remote server ssh to connect with ssh-keys and refuse password auth.
That's all the script does.

Just put your public key string in `sshKeys`, give the script execution right by doing a `chmod +x addNewServer.sh` and you're good to go.

Launch it with `./addNewServer.sh`. It's that simple!
