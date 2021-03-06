[![License: AGPL v3][uri_license_image]][uri_license]
[![Build Status](https://travis-ci.org/Monogramm/docker-dokos.svg)](https://travis-ci.org/Monogramm/docker-dokos)
[![Docker Automated buid](https://img.shields.io/docker/cloud/build/monogramm/docker-dokos.svg)](https://hub.docker.com/r/monogramm/docker-dokos/)
[![Docker Pulls](https://img.shields.io/docker/pulls/monogramm/docker-dokos.svg)](https://hub.docker.com/r/monogramm/docker-dokos/)
[![](https://images.microbadger.com/badges/version/monogramm/docker-dokos.svg)](https://microbadger.com/images/monogramm/docker-dokos)
[![](https://images.microbadger.com/badges/image/monogramm/docker-dokos.svg)](https://microbadger.com/images/monogramm/docker-dokos)

# Dokos Docker container

:whale: Docker image for Dokos.

This image was inspired by Monogramm's ERPNext container:

-   [Monogramm/docker-erpnext](https://github.com/Monogramm/docker-erpnext)

The concept is the following:

-   no need to provide any configuration file: everything will be automatically generated by the container through environnment variables
-   the application container sets all the environment variables, the other containers wait for setup to be done
-   attempt to provide postgresql compatibility

Check base image [Monogramm/docker-dodock](https://github.com/Monogramm/docker-dodock) for details.

Check image [Monogramm/docker-dokos-ext](https://github.com/Monogramm/docker-dokos-ext) to see how to expand this image and add custom frappe apps.

## What is Dokos ?

Open Source ERP built for the web. Fork of ERPNext.

> [Dokos](https://dokos.io/)
> [ERPNext](https://erpnext.com/)

> [gitlab dokos](https://gitlab.com/dokos/dokos)

## Supported tags

<https://hub.docker.com/r/monogramm/docker-dokos/>

<!-- >Docker Tags -->

-   develop-alpine3.12  (`images/develop/alpine3.12/Dockerfile`)
-   develop-slim-buster develop  (`images/develop/slim-buster/Dockerfile`)

<!-- <Docker Tags -->

## How to run this image ?

This image does not contain the database for Dokos. You need to use either an existing database or a database container.

This image is designed to be used in a micro-service environment using docker-compose. There are basically 2 variants of the image you can choose from: `alpine` or `debian`.

## Running this image with docker-compose

-   Select the version closest to what you want in the images folder
    -   In the `docker-compose.yml`, you can comment the `build` lines, uncomment the `image` lines and edit versions to download prebuilt docker container.
-   Feel free to edit variables defined in `.env` as you see fit.
-   Run the docker-compose with `docker-compose up -d` and that's it.
-   Now, go to <http://localhost:80> to access the first run installation wizard.

## Questions / Issues

If you got any questions or problems using the image, please visit our [Github Repository](https://github.com/Monogramm/docker-dokos) and write an issue.  

[uri_license]: http://www.gnu.org/licenses/agpl.html

[uri_license_image]: https://img.shields.io/badge/License-AGPL%20v3-blue.svg
