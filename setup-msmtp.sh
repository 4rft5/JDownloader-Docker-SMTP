#!/bin/sh
# /etc/cont-init.d/99-setup-msmtp.sh

echo ">>> Installing msmtp..."
apk add --no-cache msmtp ca-certificates
echo ">>> msmtp installed."
