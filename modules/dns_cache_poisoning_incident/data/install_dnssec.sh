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