#!/bin/bash
set -e

DB_NAME="listmonkdb"
DB_PASS="S0meStr0ngP@ssword"

dnf install -y postgresql-server
postgresql-setup --initdb

PG_HBA="/var/lib/pgsql/data/pg_hba.conf"
sed -i -E \
  -e 's/^(local\s+all\s+all\s+)(peer|ident)/\1md5/' \
  -e 's/^(host\s+all\s+all\s+127\.0\.0\.1\/32\s+)\w+/\1md5/' \
  -e 's/^(host\s+all\s+all\s+::1\/128\s+)\w+/\1md5/' \
  "$PG_HBA"

systemctl enable --now postgresql

export PGPASSWORD="$DB_PASS"
createdb -U postgres $DB_NAME
psql -U postgres -c "ALTER USER postgres WITH PASSWORD '$DB_PASS';"

echo "✅ PostgreSQL installed and database '$DB_NAME' created with password auth."
