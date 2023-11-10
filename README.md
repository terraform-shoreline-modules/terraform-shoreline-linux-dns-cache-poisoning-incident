
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# DNS Cache Poisoning Incident.

DNS Cache Poisoning is a type of cyber attack aimed at manipulating the Domain Name System (DNS) servers. The attacker injects false data into the DNS cache of the server, directing users to visit a fraudulent website instead of the legitimate one. This attack can result in the theft of sensitive information or the spread of malware. DNS Cache Poisoning can affect any organization with an online presence, making it a serious threat to cybersecurity.

### Parameters

```shell
export DOMAIN="PLACEHOLDER"
export DNS_SERVER="PLACEHOLDER"
export DNS_SERVICE_NAME="PLACEHOLDER"
```

## Debug

### Check the DNS entry for a domain

```shell
nslookup ${DOMAIN}
```

### Check the DNS cache for a specific domain

```shell
sudo grep ${DOMAIN} /var/cache/bind/named_dump.db
```

### Flush the DNS cache

```shell
sudo /etc/init.d/nscd restart
```

### Check the DNS server configuration

```shell
cat /etc/resolv.conf
```

### Check the DNS server logs for errors

```shell
tail -f /var/log/syslog | grep named
```

### Check the DNS server version and software

```shell
named -v
```

### Test the DNS server for vulnerabilities

```shell
dig axfr @${DNS_SERVER} ${DOMAIN}
```

### Check the DNS server response time

```shell
dig ${DOMAIN} | grep "Query time"
```

## Repair

### Clear the DNS cache: The first step in remediation is to clear the DNS cache to remove any poisoned entries. This can be done by restarting the DNS server or flushing the cache manually.

```shell
#!/bin/bash

# Stop DNS service
service ${DNS_SERVICE_NAME} stop

# Remove DNS cache files
rm -rf /var/cache/bind/*

# Restart DNS service
service ${DNS_SERVICE_NAME} start
```

### Implement DNSSEC: DNS Security Extensions (DNSSEC) is a protocol designed to secure the DNS system against attacks like cache poisoning. Implementing DNSSEC can help prevent future attacks.

```shell
#!/bin/bash

# Install DNSSEC package
sudo apt-get update
sudo apt-get install dnssec-tools

# Generate the DNSSEC keys
sudo dnssec-keygen -a NSEC3RSASHA1 -b 2048 -n ZONE example.com

# Sign the zone file with the DNSSEC key
sudo dnssec-signzone -A -N INCREMENT -o example.com -t example.com.zone -K /etc/bind/keys

# Reload the DNS service
sudo systemctl reload bind9

# Verify DNSSEC configuration
sudo dig +dnssec example.com
```