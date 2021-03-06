##
##    Docker image for Dokos.
##    Copyright (C) 2021 Monogramm
##
##    This program is free software: you can redistribute it and/or modify
##    it under the terms of the GNU Affero General Public License as published
##    by the Free Software Foundation, either version 3 of the License, or
##    (at your option) any later version.
##
##    This program is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##    GNU Affero General Public License for more details.
##
##    You should have received a copy of the GNU Affero General Public License
##    along with this program.  If not, see <http://www.gnu.org/licenses/>.
##
FROM monogramm/docker-dodock:develop-alpine3.12

ARG VERSION=develop

# Build environment variables
ENV DOKOS_BRANCH=${VERSION} \
    DODOCK_APP_PROTECTED='frappe,erpnext' \
    DOCKER_GUNICORN_TIMEOUT=600

COPY bin/install_app.sh /usr/local/bin/install_dokos_app

# Setup Dokos
RUN set -ex; \
    tar zxf sites-base.tgz; \
    install_dokos_app erpnext 'https://gitlab.com/dokos/dokos' "${DOKOS_BRANCH}"; \
    tar zcf sites-base.tgz sites; \
    rm -rf sites/* ~/.cache

ARG TAG
ARG VCS_REF
ARG BUILD_DATE

# Build environment variables
ENV DOCKER_TAG=${TAG} \
    DOCKER_VCS_REF=${VCS_REF} \
    DOCKER_BUILD_DATE=${BUILD_DATE}

# Container labels (http://label-schema.org/)
# Container annotations (https://github.com/opencontainers/image-spec)
LABEL maintainer="Monogramm maintainers <opensource at monogramm dot io>" \
      product="Dokos" \
      version=$VERSION \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/Monogramm/docker-dokos" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Dokos" \
      org.label-schema.description="Open Source ERP built for the web" \
      org.label-schema.url="https://dokos.io/" \
      org.label-schema.vendor="DOKOS SAS" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0" \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/Monogramm/docker-dokos" \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.title="Dokos" \
      org.opencontainers.image.description="Open Source ERP built for the web" \
      org.opencontainers.image.url="https://dokos.io/" \
      org.opencontainers.image.vendor="DOKOS SAS" \
      org.opencontainers.image.version=$VERSION \
      org.opencontainers.image.authors="Monogramm maintainers <opensource at monogramm dot io>"
