
# XDR Stack

# Contents
[Introduction](#introduction)  
[Credits](#credits)


## Introduction
<<<<<<< HEAD
One of my favorite projects has been building an XDR stack. Being able to self-host a security stack that is similar in capability to the best commercial deployments is pretty nifty. This feat, however, is not accomplished in a void. 
=======
One of my favorite projects has been building an XDR stack. Being able to self-host an security stack that is similar in capability to the best commercial deployments is pretty nifty. As a basis, My stack consists of OPNSense for firewalling, Graylog for event monitoring, and Wazuh for endpoint security. There are lots of things that can be added into this as well- Velociraptor for forensics, OSQuery for threat hunting, Ansible for remediation and deployment, and N8N or Shuffle for automation to name a few.

## The Basics

### OPNSense Firewall
The firewall is our first line of defense, and OPNSense make this easy. 

### Graylog
Handles all the logs for the environment. Specific logs can be forwarded on for further processing as well

### Wazuh
Endpoint monitoring and control. It can also take logs from the firewall (I'm thinking specifically of Suricata logs) in order to enhance correlations. Some helpful additions here: OSQuery and YARA integrations, and Velociraptor for DFIR. 
>>>>>>> 4d45aafd763c524ca2d2cc37f14b4c9f9d4e568e

## Credits
[Wazuh](https://wazuh.com/)  
[SocFortress](https://www.socfortress.co/)  
[Rapid7](https://www.rapid7.com/)  
