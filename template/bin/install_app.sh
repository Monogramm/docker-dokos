#!/bin/bash

APP_NAME=${1}
APP_REPO=${2}
APP_BRANCH=${3}

cd /home/dodock/dodock-bench/

. env/bin/activate
echo -e "frappe\n${APP_NAME}" > sites/apps.txt

cd ./apps
[ "${APP_BRANCH}" ] && BRANCH="-b ${APP_BRANCH}"
git clone --depth 1 ${BRANCH} ${APP_REPO} ${APP_NAME}

cd ${APP_NAME}
sed -i -e '/frappe/d' requirements.txt
yarn
rm -rf node_modules
yarn install --production=true
yarn add node-sass

cd /home/dodock/dodock-bench/
pip3 install --no-cache-dir -e apps/${APP_NAME}
mkdir -p sites/assets/${APP_NAME}
cp -R apps/${APP_NAME}/${APP_NAME}/public/* sites/assets/${APP_NAME}
