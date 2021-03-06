#!/bin/bash

set -euo pipefail

# Create 'fuckthesuits' database, associated role
psql < sql/pre.sql

export pg_user=postgres
if [[ "$(uname -s)" != "Linux" ]]; then
    # For Mac OS X
    pg_user=$USER
fi

# More initialization
for file in sql/init*.sql; do
    psql -U $pg_user -d fuckthesuits -f "$file"
done

# Create tables
for file in sql/table*.sql; do
    psql -U $pg_user -d fuckthesuits -f "$file"
done

/bin/bash migrate.sh sql/migration*.sql
