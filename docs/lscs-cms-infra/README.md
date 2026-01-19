# LSCS CMS Infra Setup

## Tech

- Garage - object storage
- Garage WebUI - WebUI for garage
- Cloudflare - for DNS

## DNS Configuration

Make sure to point proper DNS in Cloudflare

1.  Go to dash.cloudflare.com -> Login as rnd@dlsu-lscs.org
2.  La Salle Computer Society Domains -> Records -> DNS

3.  Add the following:

> [!IMPORTANT]
> Make sure that `dash.dlsu-lscs.org` points to the correct IP address of the server

- For exposing buckets as endpoints (e.g. `<bucketname>.s3.api.dlsu-lscs.org`) - REQUIRED

```dns
CNAME | *.s3.api | dash.dlsu-lscs.org | DNS only | TTL: Auto
```

- For serving static files to the public - OPTIONAL

```dns
CNAME | *.web | dash.dlsu-lscs.org | DNS only | TTL: Auto
```

## Prepare `.env`

> [!IMPORTANT]
> Consult with the leads for the environment variables if necessary

- Example `.env` values

```env
# This is the admin URL endpoint (keep it internal) - for creating buckets, etc.
API_BASE_URL=http://garage:3903
# API_BASE_URL=https://s3.api.dlsu-lscs.org

# This is the public endpoint - for sharing links, etc.
# S3_ENDPOINT_URL=http://garage:3900
S3_ENDPOINT_URL=https://s3.api.dlsu-lscs.org

# To set up auth for the web-ui please go here: https://github.com/khairul169/garage-webui?tab=readme-ov-file#authentication
# or run this command: htpasswd -nbBC 10 'YOUR_USERNAME' 'YOUR_PASSWORD' and paste the output in here.
AUTH_USER_PASS=
```

> [!WARNING]
> After doing `htpasswd ...`, make sure to set double "$" in AUTH_USER_PASS (e.g. to `username:$$2y$$10$$ee/somethingsomethingy`)
>
> **This is important for docker to read the "$" properly.**

## Garage Configuration

1. Login to s3.app.dlsu-lscs.org with the
2. Cluster -> Connect -> Configure node id
