#!/usr/bin/env bash

# if there is a env file, source it
if [ -f "./.env" ]; then
   source ./.env
# source example else
else
   source ./.env.example
fi

# enabled repositories for the build
REPOSITORIES=$1

RPI_ARM=$(uname -m)

# enable all repositories if any specified
if [[ -z $REPOSITORIES ]]; then
    REPOSITORIES="mosquitto mosquitto-arm"
fi

# for returning later to the main directory
ROOT_DIRECTORY=`pwd`

# function for building images
function build_repository {
    # read repository configuration
    source $ROOT_DIRECTORY/$REPOSITORY/buildvars

    # build all enabled versions
    for TAG in $TAGS; do
      if [ $ARM == true ]; then
        continue
      fi
      # some verbose
      echo $'\n\n'"--> Building $NAMESPACE/$REPOSITORY:$TAG"$'\n'
      cd $ROOT_DIRECTORY/$REPOSITORY/$TAG

      if [ $USE_CACHE == true ]; then
        # build using cache
        docker build -t $NAMESPACE/$REPOSITORY:$TAG .
      fi

      if [ $USE_CACHE == false ]; then
        docker build --no-cache -t $NAMESPACE/$REPOSITORY:$TAG .
      fi
    done

    # create the latest tag
    echo $'\n\n'"--> Aliasing $LATEST as 'latest'"$'\n'
    docker tag $NAMESPACE/$REPOSITORY:$LATEST $NAMESPACE/$REPOSITORY:latest
}

# function for publishing images
function publish_repository {
    # read repository configuration
    source $ROOT_DIRECTORY/$REPOSITORY/buildvars

    # publish all enabled versions
    for TAG in $TAGS; do
      # some verbose
      echo $'\n\n'"--> Publishing $NAMESPACE/$REPOSITORY:$TAG"$'\n'
      # publish
      docker push $NAMESPACE/$REPOSITORY:$TAG
    done

    # create the latest tag
    echo $'\n\n'"--> Publishing $NAMESPACE/$REPOSITORY:latest (from $LATEST)"$'\n'
    docker push $NAMESPACE/$REPOSITORY:latest
}

# for each enabled repository
for REPOSITORY in $REPOSITORIES; do
  # build the repository
  build_repository $REPOSITORY

  # If publishing is enabled
  if [ $PUBLISH == true ]; then
    # Push the built image
    publish_repository $REPOSITORY
  fi
done

scp ./scripts/rpi-build.sh $RPI_USER@$RPI_HOST:/home/pi/
ssh $RPI_USER@$RPI_HOST:/home/pi/rpi-build.sh