# LSCS Services Backups

Generally, backup the following resources:

- Docker volumes (databases) - THE MOST IMPORTANT
- `.env` files (its values)
- Important configuration files (e.g. `garage.toml`)

---

## LSCS Core Backup Documentation

docs here

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
