#!/bin/bash -xe

APP_NAME=${1}
APP_REPO=${2}
APP_BRANCH=${3}

cd /home/dodock/dodock-bench/ || exit

. env/bin/activate

echo "${APP_NAME}" >> sites/apps.txt
cd ./apps || exit
[ "${APP_BRANCH}" ] && BRANCH="-b ${APP_BRANCH}"
git clone --depth 1 ${BRANCH} "${APP_REPO}" "${APP_NAME}"
sed -i -e '/frappe/d' "${APP_NAME}/requirements.txt"
pip3 install --no-cache-dir -e "/home/dodock/dodock-bench/apps/${APP_NAME}"

# Use exactly same setup as dokidocker
echo "Install dodock NodeJS dependencies . . ."
cd /home/dodock/dodock-bench/apps/frappe
yarn
echo "Install ${APP_NAME} NodeJS dependencies . . ."
cd /home/dodock/dodock-bench/apps/${APP_NAME}
yarn
echo "Build browser assets . . ."
cd /home/dodock/dodock-bench/apps/frappe
yarn production --app ${APP_NAME}  # Note: this is invalid call !
echo "Install dodock NodeJS production dependencies . . ."
cd /home/dodock/dodock-bench/apps/frappe
yarn install --production=true
echo "Install ${APP_NAME} NodeJS production dependencies . . ."
cd /home/dodock/dodock-bench/apps/${APP_NAME}
yarn install --production=true

cd /home/dodock/dodock-bench/ || exit
if [ -d "apps/${APP_NAME}/${APP_NAME}/public" ]; then
    mkdir -p "sites/assets/${APP_NAME}"
    cp -R "apps/${APP_NAME}/${APP_NAME}/public"/* "sites/assets/${APP_NAME}"
fi
