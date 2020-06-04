#!/bin/bash

set -o nounset

function log() {
    echo -e "${@}" >&2
}

PHPRECIPEBOOK_DB_DATASOURCE="${PHPRECIPEBOOK_DB_DATASOURCE:-Database/Postgres}"
PHPRECIPEBOOK_DB_HOST="${PHPRECIPEBOOK_DB_HOST:-localhost}"
PHPRECIPEBOOK_DB_NAME="${PHPRECIPEBOOK_DB_NAME:-phprecipebook}"
PHPRECIPEBOOK_SETUP_MODE="${PHPRECIPEBOOK_SETUP_MODE:-FALSE}"

log "PHPRECIPEBOOK_DB_DATASOURCE: ${PHPRECIPEBOOK_DB_DATASOURCE}"
log "PHPRECIPEBOOK_DB_HOST: ${PHPRECIPEBOOK_DB_HOST}"
log "PHPRECIPEBOOK_DB_NAME: ${PHPRECIPEBOOK_DB_NAME}"

log "Writing database.php from environment values"

cat <<END > ${RecipebookRoot}/Config/database.php
<?php
class DATABASE_CONFIG {
  public \$default = array(
    'datasource' =>  '${PHPRECIPEBOOK_DB_DATASOURCE}',
    'persistent' => false,
    'host'       =>  '${PHPRECIPEBOOK_DB_HOST}',
    'database'   =>  '${PHPRECIPEBOOK_DB_NAME}',
    'login'      =>  '${PHPRECIPEBOOK_DB_LOGIN:-root}',
    'password'   =>  '${PHPRECIPEBOOK_DB_PASS:-}'
  );
}
END

sed -i -e "s/Configure::write('App.setupMode', \w*);/Configure::write('App.setupMode', ${PHPRECIPEBOOK_SETUP_MODE});/" "${RecipebookRoot}/Config/core.php"

log "Waiting for postgresql..."
/usr/local/bin/wait-for-postgres.sh "${PHPRECIPEBOOK_DB_HOST}"

log "Starting apache"
exec httpd-foreground