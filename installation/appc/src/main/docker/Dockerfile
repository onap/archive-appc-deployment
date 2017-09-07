# Base ubuntu with added packages needed for ONAP
FROM onap/ccsdk-odlsli-image:latest
MAINTAINER APP-C Team (appc@lists.openecomp.org)

# Set the Env. Variable in the container to add the APPC CONFIG DIR (the SDNC_CONFIG_DIR is inherited from SDNC Image)
ENV APPC_CONFIG_DIR /opt/openecomp/appc/data/properties

# Copy the opt folder to the container's /opt folder
COPY opt /opt
RUN ln -s /opt/openecomp/appc /opt/appc

# Expose port 8181 for ODL REST calls
EXPOSE 8181
