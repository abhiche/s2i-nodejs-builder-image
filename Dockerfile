FROM node:6

ENV APP_HOME=/opt/app-root

LABEL maintainer="Abhilash Chelankara"

# Set the labels that are used for OpenShift to describe the builder image.
LABEL io.k8s.description="NodeJs 6 S2I with iterative build" \
    io.k8s.display-name="NodeJS 6" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,webserver,nodejs"
    # this label tells s2i where to find its mandatory scripts
    # (run, assemble, save-artifacts)

LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i

COPY ./.s2i/bin/ /usr/local/s2i

RUN chown -R 0 /usr/local/s2i && chmod -R 775 /usr/local/s2i

# Drop the root user and make the content of $APP_HOME owned by user 1001
RUN mkdir -p $APP_HOME && \
    chown -R 1001:0 $APP_HOME && \
    chgrp 0 $APP_HOME && \
    chmod g+rw $APP_HOME && \
    chmod g+x $APP_HOME

RUN echo "username:x:1001:0:username,,,:$APP_HOME:/bin/bash" > /etc/passwd

# - In order to drop the root user, we have to make some directories world
#   writable as OpenShift default security model is to run the container
#   under random UID.
USER 1001

EXPOSE 8080

# Set the default CMD to print the usage
CMD $APP_HOME/s2i/usage
