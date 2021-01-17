FROM monogramm/docker-dokos:v1.4

COPY docker_test.sh /docker_test.sh

USER root

RUN set -ex; \
    test 'alpine3.12' = 'slim-buster' && apt-get update && apt-get install -y --allow-unauthenticated iputils-ping sudo; \
    echo "dodock ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers: \
    pip install coverage==4.5.4; \
    pip install python-coveralls

USER dodock

# TODO QUnit (JS) Unit tests
EXPOSE 4444

# Default Chrome configuration
ENV DISPLAY=:20.0 \
    SCREEN_GEOMETRY="1440x900x24" \
    CHROMEDRIVER_PORT=4444 \
    CHROMEDRIVER_WHITELISTED_IPS="127.0.0.1" \
    CHROMEDRIVER_URL_BASE='' \
    CHROMEDRIVER_EXTRA_ARGS=''

CMD ["/docker_test.sh"]
