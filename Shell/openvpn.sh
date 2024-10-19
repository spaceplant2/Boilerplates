#! /bin/bash

#   Script to set a new nordvpn server in openvpn. This could likely be used for most providers
#   that utilize openvpn.
#   This modifies the config file to use credentials stored in /etc/openvpn/pass, adjust accordingly
#   If a config file has been mondified before, this should NOT make any file changes, but only
#   change out the softlink and restart the service.
#   You will need to adjust $path to match your configurations storage folder, and $s1 may need
#   attention as well.

path="/etc/openvpn"

xdg-open https://nordvpn.com/servers/tools/

read -p "name of server? " server
read -p "tcp or udp? " proto

p1="$path/ovpn_$proto"
s1="$server.nordvpn.com.$proto.ovpn"

echo "s1 is $s1"
echo ""
echo "p1 is $p1"

if [ -f "$p1/$s1" ]; then
    echo "$p1/$s1 exists!"
    sed -i 's/auth-user-pass$/auth-user-pass pass/' "$p1/$s1"
fi

systemctl stop openvpn
rm -v "$path/client.conf"
ln -sv "$p1/$s1" "$path/client.conf"
systemctl restart openvpn
