FROM ubuntu:20.04

ARG HANSOFT_VERSION=11.1006

# Env variables
ENV HANSOFT_SERVER_NAME="My Hansoft Server"
ENV HANSOFT_SERVER_DATABASE_NAME="My Projects"
ENV HANSOFT_SERVER_DATABASE_PASSWORD="qwerty"
ENV HANSOFT_SERVER_ADMIN_PASSWORD="qwerty"

RUN apt clean
RUN apt update

# Install needed tools
RUN apt install -y --no-install-recommends curl unzip

# Get the HansoftServer archive file
RUN curl -k -o HansoftServerX64.zip -A "Mozilla/5.0 (compatible; MSIE 7.01; Windows NT 5.0)" -L https://cache.hansoft.com/Hansoft+Server+${HANSOFT_VERSION}+Linux2.6+x64.zip

# extract archive in the opt folder
RUN unzip -d /opt/ HansoftServerX64.zip

RUN rm HansoftServerX64.zip

# Copy server config and run script
COPY run.sh /opt/

# create user Hansoft
RUN useradd -m hansoft && \
    cp /root/.bashrc /home/hansoft/ && \
    mkdir /home/hansoft/data && \
    chown -R --from=root hansoft /home/hansoft

# define working directory
WORKDIR /opt/HansoftServer

# expose Hansoft server port
EXPOSE 50256

# Set user right
RUN chown -R hansoft:hansoft /opt/
USER hansoft


CMD ["/bin/bash", "/opt/run.sh"]


