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

# if no murmur ini has been given / already set, set values and move it
if [[ ! -f "$FINAL_INI" ]]
then
    set -i "/database\s*=/ c database=$DATABASE" $TMP_INI
    set -i "/host\s*=/ c host=$HOST" $TMP_INI
    set -i "/users\s*=/ c users=$USER_COUNT" $TMP_INI
    set -i "/serverpassword\s*=/ c serverpassword=$SERVER_PASSWORD" $TMP_INI
    set -i "/welcometext\s*=/ c welcometext=$WELCOME_TEXT" $TMP_INI
    set -i "/registerName\s*=/ c registerName=$SERVER_NAME" $TMP_INI

    if [[ ! -z "$DB_DRIVER" ]]
    then
        sed -i "/dbDriver\s*=/ c dbDriver=$DB_DRIVER" $TMP_INI
        sed -i "/dbUsername\s*=/ c dbUsername=$DB_USERNAME" $TMP_INI
        sed -i "/dbPassword\s*=/ c dbPassword=$DB_PASSWORD" $TMP_INI
        sed -i "/dbHost\s*=/ c dbHost=$DB_HOST" $TMP_INI
        sed -i "/dbPort\s*=/ c dbPort=$DB_PORT" $TMP_INI
        sed -i "/dbPrefix\s*=/ c dbPrefix=$DB_PREFIX" $TMP_INI
        sed -i "/dbOpts\s*=/ c dbOpts=$DB_OPTS" $TMP_INI
    fi

    mv -f /tmp/murmur.ini /etc/murmur/murmur.ini
fi

# now start murmur
/opt/murmur/murmur.x86 -fg -v -ini $FINAL_INI
