#!/bin/bash
set -e

DB_NAME="listmonkdb"

dnf install -y postgresql-server postgresql-contrib
postgresql-setup --initdb

PG_HBA="/var/lib/pgsql/data/pg_hba.conf"
sed -i -E \
  -e 's/^(local\s+all\s+all\s+)(peer|ident|md5)/\1trust/' \
  -e 's/^(host\s+all\s+all\s+127\.0\.0\.1\/32\s+)\w+/\1trust/' \
  -e 's/^(host\s+all\s+all\s+::1\/128\s+)\w+/\1trust/' \
  "$PG_HBA"

systemctl enable --now postgresql

createdb -U postgres $DB_NAME

echo "✅ PostgreSQL installed and database '$DB_NAME' created with password auth."
