# Base ubuntu with added packages needed for ONAP
FROM onap/ccsdk-odlsli-image:v0.1.0
MAINTAINER APP-C Team (appc@lists.openecomp.org)

# Set the Env. Variable in the container to add the APPC CONFIG DIR (the SDNC_CONFIG_DIR is inherited from SDNC Image)
ENV APPC_CONFIG_DIR /opt/onap/appc/data/properties

# Copy the opt folder to the container's /opt folder
COPY opt /opt

COPY featureDir1 /opt/onap/appc/features
COPY featureDir2 /opt/onap/appc/features
COPY featureDir3 /opt/onap/appc/features
COPY featureDir4 /opt/onap/appc/features

RUN ln -s /opt/onap/appc /opt/appc

# Expose port 8181 for ODL REST calls
EXPOSE 8181
