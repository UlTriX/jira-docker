# Basics
#
FROM durdn/atlassian-base
MAINTAINER Pedro Almeida <pedro@viurdata.com>

# Install Java 8

RUN DEBIAN_FRONTEND=noninteractive apt-add-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get install oracle-java8-installer -y

# Install Jira

ENV JIRA_VERSION 7.0.7
RUN curl -Lks https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${JIRA_VERSION}-jira-${JIRA_VERSION}.tar.gz -o /root/jira.tar.gz

RUN /usr/sbin/useradd --create-home --home-dir /opt/jira --groups atlassian --shell /bin/bash jira
RUN tar zxf /root/jira.tar.gz --strip=1 -C /opt/jira
RUN chown -R jira:jira /opt/atlassian-home
RUN echo "jira.home = /opt/atlassian-home" > /opt/jira/atlassian-jira/WEB-INF/classes/jira-application.properties
RUN chown -R jira:jira /opt/jira
ADD server.xml /opt/jira/conf/server.xml
RUN mv /opt/jira/conf/server.xml /opt/jira/conf/server-backup.xml

ENV CONTEXT_PATH ROOT
ADD launch.bash /launch

# Launching Jira

WORKDIR /opt/jira
VOLUME ["/opt/atlassian-home"]
EXPOSE 8080
USER jira
CMD ["/launch"]
