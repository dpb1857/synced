#!/bin/sh

set -x

SENV=${SENV:-`/bin/pwd`/senv}

AWS_PROFILE=stage

rm -rf $SENV
mkdir $SENV
mkdir $SENV/bin
mkdir $SENV/env
mkdir $SENV/compose

cat > $SENV/env.sh <<EOF
export SENV=${SENV}
EOF
cat >> $SENV/env.sh <<'EOF'
export SPINNAKER_OPT_DIR=$SENV

# NOTE dpb: copied from /opt/spinnaker/env/*.env files,
#           they live in s3 at  s3://??? XXX

# Used by Spinnaker/front50 to persist pipelines:
export ARMORYSPINNAKER_S3_BUCKET=armory-spkr
export ARMORYSPINNAKER_S3_PREFIX=dev/$USER
export SPINNAKER_AWS_DEFAULT_REGION=us-west-2

# XXX? How do we configure which account it uses?

EOF

cat >> $SENV/bin/start.sh <<EOF
#!/bin/bash

. ${SENV}/version.manifest
cd $SENV/compose
docker-compose -f docker-compose.yml up
EOF
chmod +x $SENV/bin/start.sh

. $SENV/env.sh

cp armoryspinnaker/src/spinnaker/bin/start $SENV/bin/start-orig
cp armoryspinnaker/src/spinnaker/bin/config $SENV/bin/config-orig

##
## Copy the configs, simply from bin/config
##

# Copy configs from nightly; snippet from config script;
S3_CONFIG_ROOT=s3://armory-spkr-staging/nightly/front50/config
VERSION_PATH=${S3_CONFIG_ROOT}/versions/latest
tmp=$(mktemp -d)
aws --region ${SPINNAKER_AWS_DEFAULT_REGION} --profile ${AWS_PROFILE} s3 cp ${VERSION_PATH} ${tmp}/
. ${tmp}/latest # file should read: CONFIG_VERSION=xxxxxxx
CONFIG_SOURCE=${S3_CONFIG_ROOT}/versions/${CONFIG_VERSION}

# Now, sync the configs;
aws --region ${SPINNAKER_AWS_DEFAULT_REGION} --profile ${AWS_PROFILE} s3 sync ${CONFIG_SOURCE} ${SPINNAKER_OPT_DIR}
