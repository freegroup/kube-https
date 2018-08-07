#!/usr/bin/env bash

# call the bash script like :
#
#   ./build.sh 2.1
#
# The parameter is the version to build and deploy
# into kubernetes. stupid simple and not optimized
#
# build the docker image
VERSION=$1
PROJECT=kube-https
REPOSITORY=cp-enablement.docker.repositories.sap.ondemand.com


# causes the shell to exit if any subcommand or pipeline returns a non-zero status.
set -e

# set debug mode
#set -x


# build the new docker image
#
echo '>>> Building new image'
# Due to a bug in Docker we need to analyse the log to find out if build passed (see https://github.com/dotcloud/docker/issues/1875)
docker build --no-cache=true -t $REPOSITORY/$PROJECT:$VERSION . | tee /tmp/docker_build_result.log
RESULT=$(cat /tmp/docker_build_result.log | tail -n 1)
if [[ "$RESULT" != *Successfully* ]];
then
  exit -1
fi


echo '>>> Push new image'
docker push $REPOSITORY/$PROJECT:$VERSION

kubectl apply -f ./yaml/server_service.yaml
# Apply the YAML passed into stdin and replace the version string first
cat ./yaml/server_deployment.yaml | sed "s/$REPOSITORY\/$PROJECT/$REPOSITORY\/$PROJECT:$VERSION/g" | kubectl apply -f -
