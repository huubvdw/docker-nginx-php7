nginx-php7
==========

Docker image for NGINX and PHP7, started using Supervisor.

Build image
-----------

```bash
docker build -t huubvdw/nginx-php7 .
```


Run container
-------------
```bash
docker run \
    --name nginx-php7 \
    -p 80:80 \
    -v /path/to/local/www:/var/www/html \
    huubvdw/nginx-php7
```


Test container
--------------
```bash
http://127.0.0.1/
```


Run bash on container (for debug)
---------------------------------
```bash
docker exec -it nginx-php7 bash
```
