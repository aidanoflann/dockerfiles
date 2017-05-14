#following chain of dockerfiles:
#1) https://github.com/docker-library/buildpack-deps/blob/a0a59c61102e8b079d568db69368fb89421f75f2/jessie/curl/Dockerfile
#2) https://github.com/docker-library/buildpack-deps/blob/1845b3f918f69b4c97912b0d4d68a5658458e84f/jessie/scm/Dockerfile
#3) https://github.com/docker-library/openjdk/blob/bd3c2a9867c9dc6a9a8425a8df5c54edf0cbf2cc/8-jdk/Dockerfile
#4) https://github.com/jenkinsci/docker/blob/06306a35681df39e0dda7d464682ea08d3baf2ea/Dockerfile

# 1)
apt-get update && apt-get install -y --no-install-recommends ca-certificates curl wget && rm -rf /var/lib/apt/lists/*

# 2)
apt-get update && apt-get install -y --no-install-recommends bzr git mercurial openssh-client subversion procps && rm -rf /var/lib/apt/lists/*

# 3)
apt-get update && apt-get install -y --no-install-recommends bzip2 unzip xz-utils && rm -rf /var/lib/apt/lists/*

#{ echo '#!/bin/sh'; echo 'set -e'; echo; echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; } > /usr/local/bin/docker-java-home && chmod +x /usr/local/bin/docker-java-home

ln -svT "/usr/lib/jvm/java-8-openjdk-$(dpkg --print-architecture)" /docker-java-home
export JAVA_HOME=/docker-java-home
export JAVA_VERSION=8u121
export JAVA_DEBIAN_VERSION=8u121-b13-1~bpo8+1
export CA_CERTIFICATES_JAVA_VERSION=20161107~bpo8+1

apt-get update;
apt-get install -y openjdk-8-jdk="$JAVA_DEBIAN_VERSION" ca-certificates-java="$CA_CERTIFICATES_JAVA_VERSION"
rm -rf /var/lib/apt/lists/*;
# verify that "docker-java-home" returns what we expect
#	[ "$(readlink -f "$JAVA_HOME")" = "$(docker-java-home)" ]; \
#	\
## update-alternatives so that future installs of other OpenJDK versions don't change /usr/bin/java
#	update-alternatives --get-selections | awk -v home="$(readlink -f "$JAVA_HOME")" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }'; \
## ... and verify that it actually worked for one of the alternatives we care about
#	update-alternatives --query java | grep -q 'Status: manual'

# see CA_CERTIFICATES_JAVA_VERSION notes above
#/var/lib/dpkg/info/ca-certificates-java.postinst configure

# 4)

apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

export JENKINS_HOME=/var/jenkins_home
export JENKINS_SLAVE_AGENT_PORT=50000

user=jenkins
group=jenkins
uid=1000
gid=1000

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
groupadd -g ${gid} ${group} && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
mkdir /var/jenkins_home

# `/usr/share/jenkins/ref/` contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
mkdir -p /usr/share/jenkins/ref/init.groovy.d

export TINI_VERSION=0.14.0
export TINI_SHA=6c41ec7d33e857d4779f14d9c74924cab0c7973485d2972419a3b7c7620ff5fd

# Use tini as subreaper in Docker container to adopt zombie processes
curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 -o /bin/tini && chmod +x /bin/tini && echo "$TINI_SHA  /bin/tini" | sha256sum -c -

cp init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy

