#!/bin/bash

export PGPASSWORD="${POSTGRES_PASSWORD}"
export PGUSER="${POSTGRES_USER}"
export PGDATABASE="${POSTGRES_DB}"
export PGPORT="${POSTGRES_PORT}"

# Wait until Postgres is ready
while ! pg_isready -q -h $PGHOST
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $POSTGRES_DB"` ]]; then
  echo "Database $POSTGRES_DB does not exist. Creating..."
  createdb -E UTF8 $POSTGRES_DB -l en_US.UTF-8 -T template0
  mix ecto.create
  mix ecto.migrate
  mix run priv/repo/seeds.exs
  echo "Database $POSTGRES_DB created."
fi

./prod/rel/APPNAME/bin/APPNAME eval AppName.Release.migrate

./prod/rel/APPNAME/bin/APPNAME start