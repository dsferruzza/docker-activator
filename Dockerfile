FROM dsferruzza/openjdk
MAINTAINER David Sferruzza <david.sferruzza@gmail.com>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

 # Show versions
RUN java -version
RUN javac -version

# Install tools
RUN apt-get update \
 && apt-get install -y \
 wget \
 unzip

# Select Activator version
ENV ACTIVATOR_VERSION 1.3.7
ENV SBT_VERSION 0.13.9

# Get Activator
RUN cd /tmp && \
 wget --progress=dot:mega https://downloads.typesafe.com/typesafe-activator/$ACTIVATOR_VERSION/typesafe-activator-$ACTIVATOR_VERSION.zip && \
 unzip typesafe-activator-$ACTIVATOR_VERSION.zip && \
 mkdir /opt/typesafe && \
 mv /tmp/activator-dist-$ACTIVATOR_VERSION /opt/typesafe/activator-dist-$ACTIVATOR_VERSION && \
 ln -s /opt/typesafe/activator-dist-$ACTIVATOR_VERSION/activator /usr/local/bin/activator && \
 rm /tmp/typesafe-activator-$ACTIVATOR_VERSION.zip

# Run Activator to cache its dependencies
RUN cd /tmp && \
 activator new init play-scala && \
 cd /tmp/init && \
 sed -i "s/sbt.version=0.13.8/sbt.version=$SBT_VERSION/" project/build.properties
 activator about && \
 rm -fr /tmp/init

# Slim down image
RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/?? /usr/share/man/??_*
