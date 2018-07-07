FROM node:6

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

# Drop the root user and make the content of /opt/app-root owned by user 1001
RUN mkdir -p /opt/app-root && \
    chown -R 1001:0 /opt/app-root && \
    chgrp 0 /opt/app-root && \
    chmod g+rw /opt/app-root && \
    chmod g+x /opt/app-root

RUN echo "username:x:1001:0:username,,,:/opt/app-root:/bin/bash" > /etc/passwd

# - In order to drop the root user, we have to make some directories world
#   writable as OpenShift default security model is to run the container
#   under random UID.
USER 1001

EXPOSE 8080

# Set the default CMD to print the usage
CMD /opt/app-root/s2i/usage
