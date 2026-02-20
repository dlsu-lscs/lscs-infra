# LSCS Services Backups

Generally, backup the following resources:

- Docker volumes (databases) - THE MOST IMPORTANT
- `.env` files (its values)
- Important configuration files (e.g. `garage.toml`)

---

## LSCS Core Backup Documentation

### Applications Affected
* `core.app.dlsu-lscs.org`

### Purpose
* Automates database SQL dumps and environment variable backups.
* Designed specifically for Dokploy-managed Docker containers.
* Environment-aware: Works seamlessly on both Development (`lscsdev1`) and Deployment (`lscsprod1`) servers.

### Workflow / Steps
1. **Environment Check:** Detects the current server environment (deployment or development) based on the hostname.
2. **Container Identification:** Fetches the dynamic container IDs for the database and API based on their static base names.
3. **Directory Prep:** Creates a dedicated backup folder (`./backup/lscs-core`) if it does not already exist.
4. **Database Backup:** Executes an internal `mysqldump` command via `docker exec` to output an SQL file (`sql_backup.sql`).
5. **Environment Variables Backup:** Outputs a copy of the API's current environment variables. If a previous backup (`env_backup.env`) exists, it compares the current version to the previous version and appends only the newly added variables.

### ⚠️ Important Notes
* **Manual Execution:** This script does not currently run on an automated schedule. It must be executed manually via the terminal: `./your_script_name.sh`
* **Disaster Recovery:** Instructions on how to restore from these backup files re currently pending. (Awaiting @ej's approval to finalize the recovery protocol).

---

## LSCS Links Backup Documentation

docs here

### TODOs

- [ ] connect to lscs-links mongodb database
    - go to LSCS Infra dashboard Dokploy (`dash.dlsu-lscs.org`)
    - connect via external host (search the "why", instead of internal)
- [ ] dump existing data to a directory (search about mongodump)
- [ ] run backup script as cronjob every week

---

## LSCS CMS Backup Documentation

docs here
