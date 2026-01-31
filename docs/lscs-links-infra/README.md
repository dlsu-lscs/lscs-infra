# LSCS Links Infra

This guide is the full walkthrough documentation on how to setup LSCS Links (3 tier application, Web + API + DB)

## Prerequisites

- Deployment Server (Dokploy, Coolify, or manual) - this guide uses Dokploy (setup as of 2026-01-15 00:31)
    - Make sure that whatever deployment server you're running is already up and ready.
    - Get the public IP of this server

- Domains in Cloudflare
    - Login to [Cloudflare dashboard](dash.cloudflare.com) with the RND account (rnd@dlsu-lscs.org)
    - Point the public IP of your Deployment server (or Load Balancer IP if applicable - usually when using cloud services)

-

### LSCS Links Web

Next.js

### LSCS Links API

Express.js (with Vite)

### LSCS Links DB

MongoDB
