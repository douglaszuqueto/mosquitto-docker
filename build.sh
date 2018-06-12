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

ARCH=$(uname -m)

# enable all repositories if any specified
if [[ -z $REPOSITORIES ]]; then
    REPOSITORIES="mosquitto"
fi

# for returning later to the main directory
ROOT_DIRECTORY=`pwd`

# function for building images
function build_repository {
    # read repository configuration
    source $ROOT_DIRECTORY/$REPOSITORY/buildvars

    # build all enabled versions
    for TAG in $TAGS; do
      # some verbose
      cd $ROOT_DIRECTORY/$REPOSITORY/$TAG

      if [ $USE_CACHE == true ]; then
        # build using cache
        docker build -t $NAMESPACE/$REPOSITORY:$TAG .
        if [ $ARCH = "x86_64" ]; then
            echo $'\n\n'"--> Building $NAMESPACE/$REPOSITORY:$TAG"$'\n'
            docker build -t $NAMESPACE/$REPOSITORY:$TAG .
        fi

        if [ $ARCH = "armv7l" ]; then
            echo $'\n\n'"--> Building $NAMESPACE/$REPOSITORY:$TAG-arm"$'\n'
            docker build -t $NAMESPACE/$REPOSITORY:$TAG-arm .
        fi
      fi

      if [ $USE_CACHE == false ]; then

        if [ $ARCH = "x86_64" ]; then
            echo $'\n\n'"--> Building $NAMESPACE/$REPOSITORY:$TAG"$'\n'
            docker build --no-cache -t $NAMESPACE/$REPOSITORY:$TAG .
        fi

        if [ $ARCH = "armv7l" ]; then
            echo $'\n\n'"--> Building $NAMESPACE/$REPOSITORY:$TAG-arm"$'\n'
            docker build --no-cache -t $NAMESPACE/$REPOSITORY:$TAG-arm .
        fi
      fi
    done

    if [ $ARCH = "x86_64" ]; then
        echo $'\n\n'"--> Aliasing $LATEST as 'latest'"$'\n'
        docker tag $NAMESPACE/$REPOSITORY:$LATEST $NAMESPACE/$REPOSITORY:latest
    fi

    if [ $ARCH = "armv7l" ]; then
        echo $'\n\n'"--> Aliasing $LATEST-arm as 'latest'"$'\n'
        docker tag $NAMESPACE/$REPOSITORY:$LATEST-arm $NAMESPACE/$REPOSITORY:arm-latest
    fi

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
