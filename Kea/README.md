# Kea Configuration Examples and Explanations

I've spend an extremely long and frustrating time going through the documentation for kea, and thinking there must be a better way. So here I am gathering nearly-working configurations with notations on how to fill in your own network's information. Comments are sprinkled sparingly throughout.

# Things to Know
[The Official Documentation](https://kea.readthedocs.io/en/)

[A list of DHCP options](https://www.iana.org/assignments/bootp-dhcp-parameters/bootp-dhcp-parameters.xhtml)

[Another list of DHCP options](https://www.manageengine.com/dns-dhcp-ipam/help/standard-dhcpv4-options.html)

Kea has four pieces:
- dhcp4: IP v4 address assignment
- dhcp6: IP v6 address assignment
- dhcp-ddns: Dynamic updates to the DNS server
- ctrl-agent: Control daemon

Kea also is easily interconnected with Bind9 for DNS, and Stork for monitoring. These can all peacefully coexist on the same host machine. Distributed hosting is also fairly easy. Kea provides hot-swap backups, rather than the load-balancing approach of isc-dhcp-server.

Check out the example configuration files for different ideas. I will do my best to maintain as close to a copy and paste experience as I can. If you are unsure of how syntaxes work, look into JSON formatting for hints, and get a quality code editor for highlighting assistance.
