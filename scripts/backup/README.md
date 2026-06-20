\# Database Backup Documentation



\## LSCS Links Backup Script (`db\_backup.sh`)



\### How the script works

The `db\_backup.sh` script automates the backup of the LSCS Links MongoDB database. It uses a Dockerized `mongodump` to connect to the external database via a connection string (configured in Dokploy). It streams the backup directly into a compressed `.archive` file and saves it in the `/home/lscs/backup/lscs-links/` directory with a timestamp.



\### The applications affected

\* LSCS Links Web

\* LSCS Links API



\#### DNS Names

\* Development: `dev.links.dlsu-lscs.org`

\* Production: `links.dlsu-lscs.org`

