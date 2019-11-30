# murmur-docker
dockerfile for murmur. It will use the latest version available in alpine 3.10 (currently 1.3.0-r4)

## Simple run

This will use the default murmur.ini configuration to run the server
```docker run -d -P --name murmur anakhon/murmur-docker```

Get the superuser password with the following command:
`docker logs murmur | grep SuperUser` 

Or open the logs `docker logs murmur` and look for a line like 
```
<W>2019-11-30 21:59:04.073 1 => Password for 'SuperUser' set to 'XXXXXXXXXXX'
```

## Init-murmur

If you want to be able to personalize your configuration before running, run the following command first.
**You need to create / map a volume first, see next part**

```docker run --rm -v murmur-docker:/opt/murmur -it anakhon/murmur-docker init-murmur```

Then edit the `/var/lib/docker/volumes/murmur-docker/_data/docker-murmur.ini` file. 
You can for example set the database to be in the same folder: `database=/opt/murmur/murmur.sqlite`

## Using volume

### Create your volume 

If you want to be able to edit you configuration and/or backup the database, you might want to create a volume for it.
```bash
docker volume create --name murmur-docker
```

Then simply add the `-v` flag to the docker command. 
Example:
```bash
docker run -d -P -v murmur-docker:/opt/murmur --name murmur anakhon/murmur-docker
``` 

You can then access the volume on your host in this default location `/var/lib/docker/volumes/murmur-docker/_data` to backup / edit it. 

### Using mapped volume

If you want to map another folder of your choice, just use the mapping with `-v`
Example:
```bash
docker run -d -P -v /your/host/path/of/choice:/opt/murmur --name murmur anakhon/murmur-docker
``` 

## Exposing ports

By default, tcp and udp port 64738 are exposed. If you want to set which port to map, use `-p <Your-UDP-Port>:64738/udp -p <your-TCP-port>:64738/tcp`

## Update

To update:
1. Stop the container `docker stop murmur`
2. Pull the latest `docker pull anakhon/murmur-docker`
3. Rerun the init (for file & folder rights and other stuff) `docker run --rm -v murmur-docker:/opt/murmur -it anakhon/murmur-docker init-murmur`
4. Start the container `docker start murmur`