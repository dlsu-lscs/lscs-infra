#!/bin/sh
set -e

: "${DISCORD_WEBHOOK_URL:?Error: DISCORD_WEBHOOK_URL is not set}"

sed "s|\${DISCORD_WEBHOOK_URL}|${DISCORD_WEBHOOK_URL}|g" \
    /template/alertmanager.template.yml \
    >/output/alertmanager.yml

echo "alertmanager.yml generated successfully"
