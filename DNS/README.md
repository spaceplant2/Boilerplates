# Domain Name Services

DNS is the backbone of our interconnectivity. I will explore here some of the things I have worked with and several that I have not in order to facilitate a better understanding.

# Servers

## Bind9

The ISC's offering, and most commonly used for large scale services. I'm starting here for two reasons: first, Bind9 sets the standard for DNS servers; second, this is what I use in my environment.

### Features

*Core DNS Functions*
- Name Resolution: Translates domain names into IP addresses.
- Reverse Lookups: Translates IP addresses into domain names.
- DNSSEC: Supports DNS Security Extensions for data integrity and authenticity.
- Zone Transfers: Synchronizes zone data between DNS servers.
- Caching: Stores DNS records to improve query response times.

*Advanced Features*
- Dynamic DNS: Allows for automatic updates of DNS records.
- Load Balancing: Distributes traffic across multiple servers.
- Failover: Provides redundancy and fault tolerance.
- View-based ACLs: Restricts DNS queries based on source IP address or other criteria.
- Policy-based Routing: Routes DNS queries based on specific policies or rules.
- DNS Firewalling: Protects against DNS-based attacks.
- DNS Load Sharing: Distributes load across multiple DNS servers within a zone.

*Additional Features*
- TSIG: Supports Transaction Signatures for authenticated zone transfers.
- DNSIX: Supports DNS Infrastructure Extensions for managing DNS infrastructure.
- DNS64: Enables IPv6-only clients to access IPv4-only services.
- DNS66: Provides IPv6-only DNS resolution for IPv6-only networks.

