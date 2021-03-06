#!/bin/bash

## getting current filename and basedir
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/../.."

## apply global env
if [ -f ${BASEDIR}/scripts/conf/setenv_webmethods_provisioning.sh ]; then
    . ${BASEDIR}/scripts/conf/setenv_webmethods_provisioning.sh
fi

## apply cce env
if [ -f ${HOME}/setenv-cce.sh ]; then
    . ${HOME}/setenv-cce.sh
fi

## apply script specific env (where things needed for the provisoning are needed, like TARGET_HOST etc...)
if [ -f ${HOME}/setenv-${THIS_NOEXT}.sh ]; then
    . ${HOME}/setenv-${THIS_NOEXT}.sh
fi

if [ "x$TARGET_HOST" = "x" ]; then
    echo "error: variable TARGET_HOST is required...exiting!"
    exit 2;
fi

db_version="10.3.0.0"
db_host=$TARGET_HOST
db_port="1521"
db_sid="XE"
db_name="XE"
db_username="is_dbuser"
db_password="strong123!"
db_products="[IS]"

# Database server admin connection for storage/user creation
db_admin_username="sagdb_admin"
db_admin_password="verystrong123!"
db_tablespace_data="WEBMDATA"
db_tablespace_index="WEBMINDX"
db_tablespace_dir="/u01/app/oracle/oradata/XE"

##### apply um template
$SAGCCANT_CMD -Denv.CC_CLIENT=$CC_CLIENT \
              -Dbuild.dir=$ANT_BUILD_DIR \
              -Dinstall.dir=$INSTALL_DIR \
              -Drepo.product=$CC_REPO_NAME_PRODUCTS \
              -Drepo.fix=$CC_REPO_NAME_FIXES \
              -Denv.CC_TEMPLATE=dbcreator/template-oracle.yaml \
              -Denv.CC_ENV=dbcreator-oracle \
              -Ddb.version=${db_version} \
              -Ddb.host=${db_host} \
              -Ddb.port=${db_port} \
              -Ddb.sid=${db_sid} \
              -Ddb.name=${db_name} \
              -Ddb.username=${db_username} \
              -Ddb.password=${db_password} \
              -Ddb.products=${db_products} \
              -Ddb.admin.username=${db_admin_username} \
              -Ddb.admin.password=${db_admin_password} \
              -Ddb.tablespace.data=${db_tablespace_data} \
              -Ddb.tablespace.index=${db_tablespace_index} \
              -Ddb.tablespace.dir=${db_tablespace_dir} \
              setup_noclean

runexec=$?
exit $runexec;