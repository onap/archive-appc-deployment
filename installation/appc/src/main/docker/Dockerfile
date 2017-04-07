# Base ubuntu with added packages needed for open ecomp
FROM openecomp/sdnc-image:1.1.0-SNAPSHOT
MAINTAINER APP-C Team (appc@lists.openecomp.org)

# copy openecomp
COPY opt /opt

RUN ln -s /opt/openecomp/appc /opt/appc

# ENTRYPOINT exec /opt/opendaylight/current/bin/karaf
EXPOSE 8181
