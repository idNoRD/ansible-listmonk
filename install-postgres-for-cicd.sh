#!/bin/bash
set -e

DB_NAME="listmonkdb"
DB_PASS="S0meStr0ngP@ssword"

dnf install -y postgresql-server
postgresql-setup --initdb

# Configure password authentication in pg_hba.conf
PG_HBA="/var/lib/pgsql/data/pg_hba.conf"
sed -i 's/^host\s\+all\s\+all\s\+127.0.0.1\/32\s\+\w\+/host all all 127.0.0.1\/32 md5/' "$PG_HBA"

# Start and enable PostgreSQL
systemctl enable --now postgresql

# Create database and set password for postgres user
su - postgres -c "createdb $DB_NAME"
su - postgres -c "psql -c \"ALTER USER postgres WITH PASSWORD '$DB_PASS';\""

echo "✅ PostgreSQL installed and database '$DB_NAME' created."
