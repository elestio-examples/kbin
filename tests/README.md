<a href="https://elest.io">
  <img src="https://elest.io/images/elestio.svg" alt="elest.io" width="150" height="75">
</a>

[![Discord](https://img.shields.io/static/v1.svg?logo=discord&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=Discord&message=community)](https://discord.gg/4T4JGaMYrD "Get instant assistance and engage in live discussions with both the community and team through our chat feature.")
[![Elestio examples](https://img.shields.io/static/v1.svg?logo=github&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=github&message=open%20source)](https://github.com/elestio-examples "Access the source code for all our repositories by viewing them.")
[![Blog](https://img.shields.io/static/v1.svg?color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=elest.io&message=Blog)](https://blog.elest.io "Latest news about elestio, open source software, and DevOps techniques.")

# KBIN, verified and packaged by Elestio

[kbin](https://kbin.pub/en) is an open source reddit-like content aggregator and microblogging platform for the fediverse.

Create and moderate communities, meet people with similar interests, and develop your passions.

<img src="https://github.com/elestio-examples/kbin/raw/main/kbin.png" alt="kbin" width="800">

Deploy a <a target="_blank" href="https://elest.io/open-source/kbin">fully managed KBIN</a> on <a target="_blank" href="https://elest.io/">elest.io</a> if you want automated backups, reverse proxy with SSL termination, firewall, automated OS & Software updates, and a team of Linux experts and open source enthusiasts to ensure your services are always safe, and functional.

[![deploy](https://github.com/elestio-examples/kbin/raw/main/deploy-on-elestio.png)](https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/kbin)

# Why use Elestio images?

- Elestio stays in sync with updates from the original source and quickly releases new versions of this image through our automated processes.
- Elestio images provide timely access to the most recent bug fixes and features.
- Our team performs quality control checks to ensure the products we release meet our high standards.

# Usage

## Git clone

You can deploy it easily with the following command:

    git clone https://github.com/elestio-examples/kbin.git

Copy the .env file from tests folder to the project directory

    cp ./tests/.env ./.env

Edit the .env file with your own values.

Create data folders with correct permissions

    mkdir -p storage/media storage/caddy_config storage/caddy_data storage/postgres storage/redis storage/rabbitmq
    chmod 777 -R storage/media storage/caddy_config storage/caddy_data storage/postgres storage/redis storage/rabbitmq

Run the project with the following command

    docker-compose up -d

You can access the Web UI at: `http://your-domain:3080`

## Docker-compose

Here are some example snippets to help you get started creating a container.

    version: "3.3"

    services:
        www:
            user: 0:0
            image: elestio4test/kbin:latest
            restart: always
            command: caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
            healthcheck:
                test: ["CMD-SHELL", "curl -f http://localhost:2019/metrics || exit 1"]
            ports:
                - 172.17.0.1:3080:80
            volumes:
                - ./storage/caddy_config:/config
                - ./storage/caddy_data:/data
                - ./storage/media:/var/www/kbin/public/media
            environment:
                - SERVER_NAME=:80 # the addresss that the web server binds
                - PHP_FASTCGI_HOST=php:9000 # caddy forward traffic to this host via fastcgi
                - MERCURE_PUBLISHER_JWT_KEY=${MERCURE_JWT_SECRET}
                - MERCURE_SUBSCRIBER_JWT_KEY=${MERCURE_JWT_SECRET}
                - MERCURE_JWT_SECRET=${MERCURE_JWT_SECRET}
            depends_on:
                - php

        php:
            image: elestio4test/kbin:latest
            restart: always
            command: php-fpm
            healthcheck:
                test:
                    [
                    "CMD-SHELL",
                    "REQUEST_METHOD=GET SCRIPT_NAME=/ping SCRIPT_FILENAME=/ping cgi-fcgi -bind -connect localhost:9000 || exit 1",
                    ]
            volumes:
                - ./storage/media:/var/www/kbin/public/media
            env_file:
                - .env
            depends_on:
                - redis
                - db
                - rabbitmq

        messenger:
            image: elestio4test/kbin:latest
            restart: always
            command: bin/console messenger:consume async --time-limit=3600
            healthcheck:
                test: ["CMD-SHELL", "ps aux | grep 'messenger[:]consume' || exit 1"]
            env_file:
                - .env
            depends_on:
                - redis
                - db
                - rabbitmq

        messenger_ap:
            image: elestio4test/kbin:latest
            restart: always
            command: bin/console messenger:consume async_ap --time-limit=3600
            healthcheck:
                test: ["CMD-SHELL", "ps aux | grep 'messenger[:]consume' || exit 1"]
            env_file:
                - .env
            depends_on:
                - redis
                - db
                - rabbitmq

        redis:
            image: redis:alpine
            restart: always
            command: /bin/sh -c "redis-server --requirepass $${REDIS_PASSWORD}"
            environment:
                - REDIS_PASSWORD=${REDIS_PASSWORD}
            volumes:
                - ./storage/redis:/data
            healthcheck:
                test: ["CMD", "redis-cli", "ping"]

        db:
            image: postgres:13-alpine
            restart: always
            volumes:
                - ./storage/postgres:/var/lib/postgresql/data
            environment:
                - POSTGRES_DB=kbin
                - POSTGRES_USER=kbin
                - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}

        rabbitmq:
            image: rabbitmq:3-management-alpine
            restart: always
            environment:
                - RABBITMQ_DEFAULT_USER=kbin
                - RABBITMQ_PASSWORD=${RABBITMQ_PASSWORD}
                - RABBITMQ_DEFAULT_PASS=${RABBITMQ_PASSWORD}
            volumes:
                - ./storage/rabbitmq:/var/lib/rabbitmq
            ports:
                - 172.17.0.1:15672:15672

        # Add your favorite reverse proxy (e.g nginx) which accept incoming HTTPS
        # traffic and forward to http://www:80
        # nginx:
        #  image: nginx
        #  ports:
        #    - 443:443
        #  volumes:
        #    - ./nginx.conf:/etc/nginx/nginx.conf

### Environment variables

|          Variable          |                                             Value (example)                                             |
| :------------------------: | :-----------------------------------------------------------------------------------------------------: |
|       ADMIN_PASSWORD       |                                         nXOmEK1J-Qrzb-I6jD6mbC                                          |
|        ADMIN_EMAIL         |                                             admin@gmail.com                                             |
|          BASE_URL          |                                           https://your.domain                                           |
|           DOMAIN           |                                               your.domain                                               |
|         SMTP_HOST          |                                               172.17.0.1                                                |
|         SMTP_PORT          |                                                   25                                                    |
|     SMTP_AUTH_STRATEGY     |                                                  NONE                                                   |
|      SMTP_FROM_EMAIL       |                                             sender@mail.com                                             |
|        SERVER_NAME         |                                               your.domain                                               |
|        KBIN_DOMAIN         |                                               your.domain                                               |
|         KBIN_TITLE         |                                                  kbin                                                   |
|     KBIN_DEFAULT_LANG      |                                                   en                                                    |
|  KBIN_FEDERATION_ENABLED   |                                                  true                                                   |
|     KBIN_CONTACT_EMAIL     |                                             admin@gmail.com                                             |
|     KBIN_SENDER_EMAIL      |                                             sender@mail.com                                             |
|      KBIN_JS_ENABLED       |                                                  true                                                   |
| KBIN_REGISTRATIONS_ENABLED |                                                  true                                                   |
|  KBIN_API_ITEMS_PER_PAGE   |                                                   25                                                    |
|      KBIN_STORAGE_URL      |                                           https://your.domain                                           |
|      KBIN_META_TITLE       |                                                Kbin_Lab                                                 |
|   KBIN_META_DESCRIPTION    |                    content_aggregator_and_micro-blogging_platform_for_the_fediverse                     |
|     KBIN_META_KEYWORDS     |                              kbin_content_agregator_open_source_fediverse                               |
|      KBIN_HEADER_LOGO      |                                                  false                                                  |
|    KBIN_CAPTCHA_ENABLED    |                                                  false                                                  |
|       REDIS_PASSWORD       |                                         nXOmEK1J-Qrzb-I6jD6mbC                                          |
|         REDIS_DNS          |                                  redis://nXOmEK1J-Qrzb-I6jD6mbC@redis                                   |
|         S3_BUCKET          |                                             media.karab.in                                              |
|         S3_REGION          |                                              eu-central-1                                               |
|         S3_VERSION         |                                                 latest                                                  |
|          APP_ENV           |                                                  prod                                                   |
|         APP_SECRET         |                                    427f5e2940e5b2472c1b44b2d06e0525                                     |
|        POSTGRES_DB         |                                                  kbin                                                   |
|       POSTGRES_USER        |                                                  kbin                                                   |
|     POSTGRES_PASSWORD      |                                         nXOmEK1J-Qrzb-I6jD6mbC                                          |
|      POSTGRES_VERSION      |                                                   13                                                    |
|        DATABASE_URL        |           postgresql://kbin:nXOmEK1J-Qrzb-I6jD6mbC@db:5432/kbin?serverVersion=13&charset=utf8           |
|     RABBITMQ_PASSWORD      |                                         nXOmEK1J-Qrzb-I6jD6mbC                                          |
|  MESSENGER_TRANSPORT_DSN   |                      amqp://kbin:nXOmEK1J-Qrzb-I6jD6mbC@rabbitmq:5672/%2f/messages                      |
|         MAILER_DSN         | smtp://172.17.0.1:25?encryption=null&auth_mode=null&username=null&password=null&host=172.17.0.1&port=25 |
|        MERCURE_URL         |                                    http://www:80/.well-known/mercure                                    |
|     MERCURE_PUBLIC_URL     |                                 https://your.domain/.well-known/mercure                                 |
|     MERCURE_JWT_SECRET     |                                         nXOmEK1J-Qrzb-I6jD6mbC                                          |
|     CADDY_MERCURE_URL      |                                 https://example.com/.well-known/mercure                                 |
|  CADDY_MERCURE_JWT_SECRET  |                                         nXOmEK1J-Qrzb-I6jD6mbC                                          |
|     CORS_ALLOW_ORIGIN      |                          '^https?://(kbin.localhost\|127\.0\.0\.1)(:[0-9]+)?$'                          |
|          LOCK_DSN          |                                                  flock                                                  |
|       JWT_SECRET_KEY       |                               %kernel.project_dir%/config/jwt/private.pem                               |
|       JWT_PUBLIC_KEY       |                               %kernel.project_dir%/config/jwt/public.pem                                |
|           HTTPS            |                                                  true                                                   |

# Maintenance

## Logging

The Elestio KBIN Docker image sends the container logs to stdout. To view the logs, you can use the following command:

    docker-compose logs -f

To stop the stack you can use the following command:

    docker-compose down

## Backup and Restore with Docker Compose

To make backup and restore operations easier, we are using folder volume mounts. You can simply stop your stack with docker-compose down, then backup all the files and subfolders in the folder near the docker-compose.yml file.

Creating a ZIP Archive
For example, if you want to create a ZIP archive, navigate to the folder where you have your docker-compose.yml file and use this command:

    zip -r myarchive.zip .

Restoring from ZIP Archive
To restore from a ZIP archive, unzip the archive into the original folder using the following command:

    unzip myarchive.zip -d /path/to/original/folder

Starting Your Stack
Once your backup is complete, you can start your stack again with the following command:

    docker-compose up -d

That's it! With these simple steps, you can easily backup and restore your data volumes using Docker Compose.

# Links

- <a target="_blank" href="https://codeberg.org/Kbin/kbin-core#kbin">Kbin documentation</a>

- <a target="_blank" href="https://github.com/ernestwisniewski/kbin">Kbin Github repository</a>

- <a target="_blank" href="https://github.com/elestio-examples/kbin">Elestio/kbin Github repository</a>
