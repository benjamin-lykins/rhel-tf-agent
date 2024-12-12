
FROM redhat/ubi9:latest

# set the tfc-agent version
ARG AGENT_VERSION="1.17.3"

# Create a user and group to run the agent
RUN groupadd --system tfc-agent
RUN useradd --system --create-home --gid tfc-agent tfc-agent

# Install 
# https://developer.hashicorp.com/terraform/cloud-docs/agents/requirements#software-requirements
RUN dnf upgrade -y && dnf install -y \
    git \
    wget \
    jq \
    unzip \
    tar \
    gzip

# Download the agent
RUN curl -L -o \
    /tmp/tfc-agent_${AGENT_VERSION}_linux_amd64.zip \
    https://releases.hashicorp.com/tfc-agent/${AGENT_VERSION}/tfc-agent_${AGENT_VERSION}_linux_amd64.zip

# Unzip the agent and place it in the tfc user's home directory
RUN unzip /tmp/tfc-agent_${AGENT_VERSION}_linux_amd64.zip -d /home/tfc-agent/

# Set the permissions on the agent
RUN chown -R tfc-agent:tfc-agent /home/tfc-agent

# Cleanup the zip file
RUN rm /tmp/tfc-agent_${AGENT_VERSION}_linux_amd64.zip

# Set the user to run the agent
USER tfc-agent

# Set the working directory
WORKDIR /home/tfc-agent

# Set the entrypoint
ENTRYPOINT [ "/home/tfc-agent/tfc-agent"]