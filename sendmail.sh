#!/bin/sh
export MSMTPRC=/etc/msmtprc

RECIPIENT="recipient@yourhost.com"

INPUT="$*"

ITEM=$(echo "$INPUT" | head -n1)
LOCATION=$(echo "$INPUT" | tail -n1)

BODY="JDownloader has finished downloading: $ITEM\nIt can be found at: $LOCATION\n\nDon't forget to remove it from the WebUI and delete it after copying out."

SUBJECT="JDownloader Finished: $ITEM"

echo -e "Subject: $SUBJECT\n\n$BODY" | /usr/bin/msmtp "$RECIPIENT"
