#!/bin/sh
TMP_INI=/tmp/murmur.ini
FINAL_INI=/etc/murmur/murmur.ini

set -e
# force UID / GID of murmur user, in case we want it to match host values
if [[ $GID != 1000 ]]
then
    delgroup murmur
    addgroup -g $GID murmur
fi
if [[ $UID != 1000 ]]
then
    deluser murmur
    adduser -DS -s /bin/false -u 1000 -G murmur murmur
fi

# set prop function
function setProp {
  local prop=$1
  local var=$2
  if [ -n "$var" ]; then
    echo "Setting $prop to $var"
    sed -i "/$prop\s*=/ c $prop=$var" $TMP_INI
  fi
}

# if no murmur ini has been given / already set, set values and move it
if [[ ! -f "$FINAL_INI" ]]
then
    setProp "database" "$DATABASE"
    setProp "host" "$HOST"
    setProp "users" "$USER_COUNT"
    setProp "serverpassword" "$SERVER_PASSWORD"
    setProp "welcometext" "$WELCOME_TEXT"
    setProp "registerName" "$SERVER_NAME"

    if [[ ! -z "$DB_DRIVER" ]]
    then
        setProp "dbDriver" "$DB_DRIVER"
        setProp "dbUsername" "$DB_USERNAME"
        setProp "dbPassword" "$DB_PASSWORD"
        setProp "dbHost" "$DB_HOST"
        setProp "dbPort" "$DB_PORT"
        setProp "dbPrefix" "$DB_PREFIX"
        setProp "dbOpts" "$DB_OPTS"
    fi

    mv -f /tmp/murmur.ini /etc/murmur/murmur.ini
fi

# now start murmur
/opt/murmur/murmur.x86 -fg -v -ini $FINAL_INI
