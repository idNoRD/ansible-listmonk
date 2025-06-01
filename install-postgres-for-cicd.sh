#!/bin/bash
set -e

DB_NAME="listmonkdb"

sudo dnf install -y postgresql-server
sudo postgresql-setup --initdb
sudo systemctl enable --now postgresql
# Create a DB using the 'postgres' OS and DB user
sudo -u postgres createdb $DB_NAME

echo "✅ PostgreSQL installed and database '$DB_NAME' created for user postgres"
