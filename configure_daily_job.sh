#!/bin/bash

echo "0 4 * * * root cd /srv/docker/backup && ./config.sh >/dev/null 2>&1" | sudo tee -a /etc/crontab >/dev/null
