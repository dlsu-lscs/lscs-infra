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

## Garage Configuration

> [!NOTE]
> There are two components in this Garage deployment:
>
> (1) Garage WebUI - the accessible website of Garage,
> (2) Garage - the object storage itself that has S3-compatible API, etc.
>
> **It's important to know the distinction between the two**

### Prepare environment variables for Garage and deployment

> [!IMPORTANT]
> Consult with the leads for the environment variables if necessary

1. Get `.env` values

- The `https://s3.api.dlsu-lscs.org` is the object storage API server (see notes below).

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

2. Then deploy - click "Deploy" in Dokploy

> [!IMPORTANT]
> Make sure that there are no errors (you can login to the WebUI, etc.)
>
> **If you encounter an error, resolve it and make sure to REDEPLOY (click "Deploy" again) for the changes to be applied.**

### Setup Nodes, Keys, and Buckets in Garage WebUI

1. Login to s3.app.dlsu-lscs.org with the
2. Cluster -> Connect -> Get node id by executing the command provided in the server (`ssh` into the server and run the command) -> Save
3. Click three dots on the newly connected node -> Assign
4. Enter values:

```
Node ID: <keep it>
Zone: dc1
Capacity: <actual-storage-space-of-vps>
Gateway: DON'T CHECK (false)
Tags (optional): prod
```

5. Go to Keys -> Create Key -> Name: `LSCS_CMS_BUCKET` or something -> Submit
6. Go to Buckets -> Create Buckets -> Name: `cms` or something -> Submit
7. Click "Manage" in the newly created bucket -> Permissions -> Allow Key -> Select the created key in Step 5 (e.g. `LSCS_CMS_BUCKET`)

## LSCS CMS Application Setup

### Create LSCS CMS DB (dbcms)

This is a postgres database

1. If using Dokploy, create a database in the same project
2. Choose postgres -> configure values
    - Its recommended to set the ff values:

    ```
    Database Name: dbcms
    User: lscs
    Password: <generate with: openssl rand -hex 32>
    ```

3. Set external port to something like 54327 (unused port in the server)

    > [!NOTE]
    > Make sure to open port in `ufw` firewall (if firewall is enabled in the server)
    >
    > To check, ssh in the server and run `sudo ufw status`

4. Deploy

---

### Deploy LSCS CMS Application

1. Prepare `.env` values and put it in the Environment tab of the deployment (if using Dokploy)

> [!IMPORTANT]
> Again, consult with the leads for the environment variables if necessary

```env
DATABASE_URI=<from-the-created-dbcms>
PAYLOAD_SECRET=<openssl rand -hex 32>
PAYLOAD_AUTH_SECRET=<openssl rand -hex 32>

NEXT_PUBLIC_SERVER_URL=https://cms.app.dlsu-lscs.org
NEXT_PUBLIC_PAYLOAD_AUTH_URL=https://cms.app.dlsu-lscs.org

GOOGLE_CLIENT_SECRET=<check-in-rnd-google-console>
GOOGLE_CLIENT_ID=<check-in-rnd-google-console>

LSCS_CORE_API_TOKEN=<request-lscs-core-api-key-from-below-url>
LSCS_CORE_API_URL=https://core.api.dlsu-lscs.org

S3_SECRET_ACCESS_KEY=<from-garage-cms-bucket>
S3_ACCESS_KEY_ID=<from-garage-cms-bucket>
S3_BUCKET=cms
S3_ENDPOINT=https://s3.api.dlsu-lscs.org
S3_REGION=garage # this is from garage.toml (see Advanced tab in the Garage deployment in Dokploy), "garage" is the default value

CMS_URL=https://cms.app.dlsu-lscs.org/api
CMS_API_KEY=
```

2. Run migrations for the database (LSCS CMS DB)

- Run migrations

```bash
pnpm run migrate
```

- To check migration status

```bash
pnpm run migrate:status
```

3. If environment variables are filled up properly, then deploy the LSCS CMS application
