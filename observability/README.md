# Observability Stack

Self-hosted monitoring for Dokploy deployments using Prometheus + Grafana.

## Stack Components

| Component | Purpose |
|---|---|
| **Prometheus** | Metrics collection and storage |
| **Grafana** | Dashboards + alerting UI |
| **node_exporter** | System metrics (CPU, RAM, disk) |
| **cAdvisor** | Container-level metrics |
| **Alertmanager** | Routes alerts to Discord |

## Dokploy Step-by-Step Setup

### 1. Push to Git

Dokploy Docker Compose supports **Git as a source**, which preserves the directory structure needed for volume mounts.

1. Push this directory (or your entire project) to a Git repository (GitHub, GitLab, etc.)
2. Ensure the file structure is intact:
   ```
   observability/
   ├── docker-compose.yml
   ├── alertmanager/
   │   └── alertmanager.yml
   ── prometheus/
       ├── prometheus.yml
       └── alerts/
           └── system-alerts.yml
   ```

### 2. Create the Application in Dokploy

1. In Dokploy, create a new **Docker Compose** application
2. Set **Source Type** to **Git**
3. Enter your repository URL
4. Set the **Branch** (e.g., `main`)
5. Set **Subdirectory** to `observability` (or wherever your compose file lives)
6. Click **Deploy**

> Dokploy will clone the repo and use the directory structure as-is, so all relative volume mounts work automatically.

### 3. Configure Environment Variables

Copy `.env.example` to `.env` and edit it:

```bash
cp .env.example .env
```

Set your values in `.env`:

| Variable | Default | Action |
|---|---|---|
| `GF_SECURITY_ADMIN_USER` | `admin` | Change if desired |
| `GF_SECURITY_ADMIN_PASSWORD` | `CHANGE_ME` | Set a strong password |
| `GF_SERVER_ROOT_URL` | `https://grafana.yourdomain.com` | Update to your actual domain |

> **Important:** Add `.env` to your `.gitignore` — never commit secrets to version control.

### 4. Update Discord Webhook

Replace the webhook URL in `alertmanager/alertmanager.yml`:

```yaml
receivers:
  - name: 'discord'
    webhook_configs:
      - url: 'https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN'
        send_resolved: true
```

> This file is in `.gitignore` so it won't be committed.

### 5. Configure Domains

1. Go to the **Domains** tab of your Docker Compose application
2. Add domains for each service:
   - `prometheus.yourdomain.com` → Port `9090`
   - `grafana.yourdomain.com` → Port `3000`
   - `alertmanager.yourdomain.com` → Port `9093`
3. **Redeploy** the application (Docker Compose requires redeploy after domain changes)

### 6. Import Grafana Dashboards

After Grafana is up:

1. Log in to Grafana (`admin` / your password)
2. **Add the Prometheus data source** (if not auto-configured):
   - Go to **Connections** → **Data Sources** → **Add data source**
   - Select **Prometheus**
   - Set the URL to `http://prometheus:9090` (internal Docker network)
   - Click **Save & Test** — it should show "Data source is working"
3. **Import the Node Exporter dashboard**:
   - Go to **Dashboards** → **Import** (or use the `+` icon → **Import**)
   - In the **Import via grafana.com** field, enter `1860`
   - Click **Load**
   - Give the dashboard a name (or keep the default "Node Exporter Full")
   - Under **Prometheus**, select the data source you added in step 2
   - Click **Import**
4. **Import the cAdvisor dashboard**:
   - Repeat step 3, but enter dashboard ID `14282`
   - Select the same Prometheus data source
   - Click **Import**
5. Verify both dashboards appear under **Dashboards** → **Browse** and show live data

## Quick Setup

1. Push this directory to a Git repository
2. Copy `.env.example` to `.env` and set your credentials + Discord webhook URL
3. Create a Docker Compose app in Dokploy from **Git source**
4. Set subdirectory to `observability`
5. Configure domains (see step 5 above)
6. Import Grafana dashboards (see step 6 above)

## Getting Discord Webhook URL

1. Go to your Discord server
2. Channel settings → Integrations → Webhooks → New Webhook
3. Copy the webhook URL
4. Paste it into `alertmanager/alertmanager.yml`

## Access URLs

Once deployed and DNS is configured:

- **Grafana**: `https://grafana.yourdomain.com`
- **Prometheus**: `https://prometheus.yourdomain.com`
- **Alertmanager**: `https://alertmanager.yourdomain.com`

## Alert Thresholds

| Alert | Threshold | Severity |
|---|---|---|
| High CPU | > 80% for 5 min | warning |
| High Memory | > 85% for 5 min | warning |
| Low Disk Space | > 85% for 5 min | critical |
| Container Down | No metrics for 2 min | critical |

## Dokploy Caveats

### No `container_name`

Dokploy docs state: **Don't set `container_name` property** on services. It causes issues with logs, metrics, and other Dokploy features. Dokploy manages container naming automatically.

### Traefik Network

All services must be attached to the `dokploy-network` external network. This is already configured in the compose file.

### Domain Changes Require Redeploy

Unlike Dokploy Applications (which use Traefik file provider with hot reload), Docker Compose uses labels. Any domain change requires a full redeployment.

### Resource Usage

This stack uses ~500MB-1GB RAM depending on scrape interval and data retention. Ensure your server has enough headroom.
