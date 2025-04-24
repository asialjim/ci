#!/bin/bash

perform_release() {
    cd /app || exit 1
    CURRENT_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
    RELEASE_VERSION=${CURRENT_VERSION%-SNAPSHOT}
    NEW_VERSION=$(echo $RELEASE_VERSION | awk -F. '{$NF = $NF + 1; print $0}' | sed 's/ /./g')-SNAPSHOT

    mvn clean install
    mvn clean release:prepare -B \
        -Prelease,!dev \
        -DreleaseVersion=$RELEASE_VERSION \
        -DdevelopmentVersion=$NEW_VERSION \
        -DasialjimVersion=$RELEASE_VERSION
    mvn install
    mvn release:perform -B -DasialjimVersion=$RELEASE_VERSION
}

perform_release