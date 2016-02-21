#!/bin/bash
#
# This script sets up the dev and test databases. These credentials should
# match the values in <rails_root>/config/application.yml.  Do not put
# production credentials in here!

# local development enviornment
sudo -u postgres bash -c "psql -c \"create user rt_pg_dev_user with password 'pgdevpwd';\""
sudo -u postgres bash -c "createdb -Ort_pg_dev_user rt_dev"

# local test environment
sudo -u postgres bash -c "psql -c \"create user rt_pg_test_user with password 'pgtestpwd';\""
sudo -u postgres bash -c "psql -c 'alter role rt_pg_test_user with superuser'"

sudo -u postgres bash -c "createdb -Ort_pg_test_user rt_test"

# tell postgres to use password authentication
sudo sed -i 's/\(^local.*all.*all.*\)peer$/\1md5/' /etc/postgresql/9.4/main/pg_hba.conf
