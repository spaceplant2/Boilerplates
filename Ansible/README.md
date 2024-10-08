# Ansible Automations

Ansible automates configuration and setup of pretty much anything you could want. AN example of some easy tasks would be running updates, installing patches, setting programs configurations, and installing software. I have several examples of playbooks that have been genericized and sterilized. You will need to modify the playbooks and accompanying config files for your environment.

## Chrony

Crony is a replacement for ntpd. This playbook will remove ntpd, set up all devices in the *ntpServers* groups as time servers, and install chrony as a listener on all other devices. Note that it is not really helpful to have multiple time servers on the same network. 

[chrony playbook](chrony.yml) - change the path for the configuration file sources
[server config](chrony.server.conf) - Change the allow directive and add or remove servers as desired
[client config](chrony.client.conf) - change the server IP

# SSH Key update

There are so many things that can go wrong while rotating SSH keys that I decided it was necessary to find a way to minimize the risks. [This module](https://docs.ansible.com/ansible/latest/collections/ansible/posix/authorized_key_module.html) is an ansible built-in that works directly with the file `~/.ssh/authorized_keys`. My playbook hedges bets by allowing multiple keys to be installed. This should prevent a lockout due to typos, incorrect keys, or missing keys.

[ssh key playbook](ssh-key-update.yml) - change the loginaccount and file paths in both tasks

# Wazuh

Install the Wazuh XDR endpoint on Debian based devices. Of course you will want to have a Wazuh server running first- see [my Security Stack repo](https://github.com/spaceplant2/SecurityStack) for an explanation of what this is and why you might want it. There is even a task to install docker monitoring modifications.

[wazuh playbook](wazuh-debian.yml) - lots of modifications needes
