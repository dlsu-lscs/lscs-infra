#!/bin/bash

DISCORD_WEBHOOK_URL="YOUR_DISCORD_WEBHOOK_URL_HERE"
HOSTNAME=$(hostname)

trivy fs --severity HIGH,CRITICAL --ignore-unfixed --format json / >/tmp/trivy-report.json

VULN_COUNT=$(jq 'if.Results then.Vulnerabilities //] | flatten | length else 0 end' /tmp/trivy-report.json)

if; then
  MESSAGE="{\"content\": \"🚨 **Vulnerability Alert on ${HOSTNAME}**\nFound **${VULN_COUNT}** new HIGH or CRITICAL vulnerabilities. Please review the full report at \`/tmp/trivy-report.json\` on the server.\"}"

  curl -H "Content-Type: application/json" -X POST -d "$MESSAGE" "$DISCORD_WEBHOOK_URL"
fi
