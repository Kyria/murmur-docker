# murmur-docker
dockerfile for murmur with auto check version

## Simple run
```docker run -d -p 64738:64738/tcp -p 64738:64738/udp --name murmur anakhon/murmur-docker```

## Database
By default, this container save data in ```/opt/db/murmur.sqlite``` in the container, so you will need to map volumes to save it on your host
```docker run -d -p 64738:64738/tcp -p 64738:64738/udp -v /your/path/to/murmur.sqlite:/opt/db/murmur.sqlite --name murmur anakhon/murmur-docker```

If you want to use another database (such as MySQL), you will need to bind environnement variables to achieve that.
By default, the container will set database data in murmur.ini if you give ```DB_DRIVER```

```
DATABASE=your database name
DB_DRIVER=db driver (see murmur doc)
DB_USERNAME=db username
DB_PASSWORD=db password
DB_HOST=db host
DB_PORT=db port (default: 3306)
DB_PREFIX=db table prefix (default: murmur_)
DB_OPTS=additionnal options (default: "UNIX_SOCKET=/opt/db/mysqld.sock")
```

If you use your host database, you can simply map your socket to the one in the container (DB_OPTS)

If you want to use a container network / link, set DB_OPTS to empty, and set the host as you need it.

Example using host socket :
```
docker run -d -p 64738:64738/tcp -p 64738:64738/udp --name mumble \
 -e DB_DRIVER=QMYSQL -e DB_USERNAME=mumble -e DB_PASSWORD=somepwd -e DB_HOST=localhost \
 -e SERVER_NAME=mumble -v /var/run/mysqld/mysqld.sock:/opt/db/mysqld.sock \
 -e DATABASE=mumble -e SERVER_PASSWORD=pass anakhon/mumble-docker
```

## environnement variables
The full list is the following
```
DATABASE=your database name
DB_DRIVER=db driver (see murmur doc)
DB_USERNAME=db username
DB_PASSWORD=db password
DB_HOST=db host
DB_PORT=db port (default: 3306)
DB_PREFIX=db table prefix (default: murmur_)
DB_OPTS=additionnal options (default: "UNIX_SOCKET=/opt/db/mysqld.sock")
HOST=the host to bind (default: 0.0.0.0)
USER_COUNT=max user on the server (default: 50)
SERVER_PASSWORD=your server password \
WELCOME_TEXT=the welcome text \
SERVER_NAME=the server name
UID=the murmur user ID (default:1000)
GID=the murmur group ID (default:1000)

```
