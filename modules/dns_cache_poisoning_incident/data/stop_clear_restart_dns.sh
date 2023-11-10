#!/bin/bash

# Stop DNS service
service ${DNS_SERVICE_NAME} stop

# Remove DNS cache files
rm -rf /var/cache/bind/*

# Restart DNS service
service ${DNS_SERVICE_NAME} start