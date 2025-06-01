#!/bin/bash
set -e

DB_NAME="listmonkdb"

dnf install -y postgresql-server
postgresql-setup --initdb
systemctl enable --now postgresql
# Create a DB using the 'postgres' OS and DB user
su - postgres -c "createdb $DB_NAME"

echo "✅ PostgreSQL installed and database '$DB_NAME' created for user postgres"
