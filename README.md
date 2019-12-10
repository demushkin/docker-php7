# docker-php7

php7.4-fpm Dockerfile with imagick, blitz, pdo_mysql

docker-compose.yml example:

```
version: "3"

services:

    php7:
        image: demushkin/php7:latest
        volumes:
            - ../:/var/www
```
