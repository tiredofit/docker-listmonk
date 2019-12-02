
# hub.docker.com/r/tiredofit/listmonk

[![Build Status](https://img.shields.io/docker/build/tiredofit/listmonk.svg)](https://hub.docker.com/r/tiredofit/listmonk)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/listmonk.svg)](https://hub.docker.com/r/tiredofit/listmonk)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/listmonk.svg)](https://hub.docker.com/r/tiredofit/listmonk)
[![Docker Layers](https://images.microbadger.com/badges/image/tiredofit/listmonk.svg)](https://microbadger.com/images/tiredofit/listmonk)


# Introduction

This will build a container for [listmonk](https://listmonk.app/) - An open source mailing list manager built in Go.

* Automatically installs and sets up installation upon first start
* Allows for authentication with included Nginx frontend
        
* This Container uses a [customized Alpine Alpine base](https://hub.docker.com/r/tiredofit/alpine) which includes [s6 overlay](https://github.com/just-containers/s6-overlay) enabled for PID 1 Init capabilities, [zabbix-agent](https://zabbix.org) for individual container monitoring, Cron also installed along with other tools (bash,curl, less, logrotate, nano, vim) for easier management. It also supports sending to external SMTP servers..

[Changelog](CHANGELOG.md)

# Authors

- [Dave Conroy](https://github.com/tiredofit)

# Table of Contents

- [Introduction](#introduction)
    - [Changelog](CHANGELOG.md)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
    - [Data Volumes](#data-volumes)
    - [Environment Variables](#environmentvariables)   
    - [Networking](#networking)
- [Maintenance](#maintenance)
    - [Shell Access](#shell-access)
   - [References](#references)

# Prerequisites

This image assumes that you are using a reverse proxy such as 
[jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) and optionally the [Let's Encrypt Proxy 
Companion @ 
https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion) 
in order to serve your pages. However, it will run just fine on it's own if you map appropriate ports. See the examples folder for a docker-compose.yml that does not rely on a reverse proxy.

You will also need an external Postgresql container

# Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/listmonk) and is the recommended method of installation.


```bash
docker pull tiredofit/listmonk
```

# Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Configure database backend.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
* Make [networking ports](#networking) available for public access if necessary

*The first boot can take from 2 minutes - 5 minutes depending on your CPU to setup the proper schemas.

Login to the web server and enter in your admin email address, admin password and start configuring the system!

# Configuration

### Data-Volumes

The following directories are used for configuration and can be mapped for persistent storage.

| Directory    | Description                                                 |
|--------------|-------------------------------------------------------------|
| `/data` | Volatile information for uploads, configuration |

### Environment Variables

Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/alpine), and [Web Image](https://hub.docker.com/r/tiredofit/nginx-php-fpm) below is the complete list of available options that can be used to customize your installation.

| Parameter        | Description                            |
|------------------|----------------------------------------|
| `ADMIN1_USER` | Administrator username - Only used if `ENABLE_NGINX=TRUE` - Default `admin` |
| `ADMIN1_PASS` | Administrator Password - Only used if `ENABLE_NGINX=TRUE` - Default `listmonk` | 
| `ADMIN2_USER` | As above, keep incrementing if you wish to have more users |
| `ADMIN2_PASS` | As above, keep incrementing if you wish to have more passwords | 
| `DB_ENABLE_SSL` | Utilize SSL for connecting to the database - Default `disable` |
| `DB_HOST` | Host or container name of Postgres Server e.g. `listmonk-db` |
| `DB_PORT` | MariaDB Port - Default `5432` |
| `DB_NAME` | MariaDB Database name e.g. `listmonk` |
| `DB_USER` | MariaDB Username for above Database e.g. `listmonk` |
| `DB_PASS` | MariaDB Password for above Database e.g. `password`|
| `DISPLAY_ERRORS` | Display Errors on Website - Default `FALSE`|
| `ENABLE_NGINX` | Utilize Nginx for Authentication - Default `TRUE` |
| `ENABLE_SSL_PROXY` | If using SSL reverse proxy force application to return https URLs `TRUE` or `FALSE` |
| `FROM_EMAIL` | From Email Information - Default `Listmonk <listmonk@example.com>` |
| `LISTEN_PORT` | Listmonk Listening Port - Default `9000` - Useful if not wanting to use included nginx webserver |
| `MAX_CONCURRENT_WORKERS` | Maximum concurrent workers that will attempt to send messages simultaneously. - Default `100`
| `MAX_SEND_ERRORS` | The number of errors (eg: SMTP timeouts while e-mailing) a running campaign should tolerate. `0` to disable - Default `1000`
| `PRIVACY_ENABLE_BLACKLIST` | Allow subscribers to unsubscribe from all mailing lists and mark themselvesas blacklisted? - `true` / `false` - Default `true` |
| `PRIVACY_ENABLE_EXPORT` | Allow subscribers to export data recorded on them? - `true` / `false` - Default `true` |
| `PRIVACY_ENABLE_WIPE` |  Allow subscribers to delete themselves from the database? - `true` / `false` - Default `true` |
| `PRIBACY_EXPORTABLE_ITEMS` | Items to include in data export.  `profile`     Subscriber's profile including custom attributes,
`subscriptions` - Subscriber's subscription lists (private list names are masked),
`campaign_views` -Campaigns the subscriber has viewed and the view counts,
`link_clicks` - Links that the subscriber has clicked and the click counts - Default "profile,subscriptions,campaign_views,link_clicks" |
| `SETUP_TYPE` | Automatically generate configuration on startup - `AUTO` or `MANUAL` - Default `AUTO` |
| `SMTP1_HOST` | Hostname of SMTP Server eg `smtp-server` |
| `SMTP1_NAME` | Friendly name of SMTP Server eg `InternalMailserver` |
| `SMTP1_PORT` | Port for `SMTP_HOST` - eg 25 |
| `SMTP1_AUTH_PROTOCOL` | Protocol for SMTP authentication - `cram` or `plain` |
| `SMTP1_USER` | Username if needed for SMTP User |
| `SMTP1_PASS` | Password is needed for SMTP User |
| `SMTP1_MAX_CONNECTIONS` | Maximum Connections to the SMTP Server - Default `10` |
| `SMTP1_SEND_TIMEOUT` | Maximum time in milliseconds to wait per e-mail push - Default `5000` |
| `UPLOADS_PROVIDER_TYPE` | Where to store uploads `filesystem` or `s3` - Default `filesystem` |
| `UPLOADS_FILESYSTEM_PATH` | Path to downloads default `/data/uploads`
| `UPLOADS_FILESYSTEM_URI` | URL thats visible to the outside world - Default `/uploads` |
| `UPLOADS_S3_AWS_REGION` | - AWS Region where S3 bucked is hosted - Default `ap-south-1`
| `UPLOADS_S3_BUCKET_TYPE` | Bucket Type - `private` or `public`
| `UPLOADS_S3_EXPIRY` | TTL in seconds for presigned URL - Only used if bucket is private - Default `86400`
| `UPLOADS_S3_AWS_KEY_ID` | AWS Access Key for Bucket
| `UPLOADS_S3_AWS_KEY_SECRET` | AWS Secret Key for Bucket 
| `UPLOADS_S3_BUCKET_NAME` | S3 Bucket Name - Default (blank) |
| `UPLOADS_S3_BUCKET_PATH` | Path where files are stored inside bucket - Empty value means root |
| `SITE_URL` | The url your site listens on example `https://listmonk.example.com`|

### Networking

The following ports are exposed.

| Port      | Description   |
|-----------|---------------|
| `80`      | HTTP          |
| `9000`    | Listmonk HTTP |

# Maintenance

#### Shell Access

For debugging and maintenance purposes you may want access the containers shell. 

```bash
docker exec -it (whatever your container name is e.g. listmonk) bash
```

# References

* https://listmonk.app/
