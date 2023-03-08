#! /usr/bin/env bash

# Let the DB start
# python ./pandora/api/web_pre_start.py

# Run migrations
alembic upgrade head

# Create initial data in DB
python ./pandora/initial_data.py