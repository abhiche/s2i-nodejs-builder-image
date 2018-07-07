FROM node:6

LABEL maintainer="Abhilash Chelankara"

# Set the labels that are used for OpenShift to describe the builder image.
LABEL io.k8s.description="NodeJs 6 S2I with iterative build" \
    io.k8s.display-name="NodeJS 6" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,webserver,nodejs" \
    # this label tells s2i where to find its mandatory scripts
    # (run, assemble, save-artifacts)
    io.openshift.s2i.scripts-url="image:///opt/app-root/s2i"

RUN mkdir -p /opt/app-root

# Copy the S2I scripts to /opt/app-root since we set the label that way

COPY ./.s2i/bin/ /opt/app-root/s2i

RUN chmod -R +x /opt/app-root/s2i/

# set a random user
USER 1001

EXPOSE 8080

# Set the default CMD to print the usage
CMD /opt/app-root/s2i/usage
