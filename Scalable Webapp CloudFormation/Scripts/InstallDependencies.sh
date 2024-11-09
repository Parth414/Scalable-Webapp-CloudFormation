#!/bin/bash
echo "Installing dependencies..."
apt-get update
apt-get install -y python3-pip
pip3 install -r /var/www/html/src/app/requirements.txt
