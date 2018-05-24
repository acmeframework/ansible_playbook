# Alpine OS 3.4
# http://dl-cdn.alpinelinux.org/alpine/v3.4/community/x86_64/

FROM alpine:3.4

RUN set -x && \
  apk add --update \
    bash \
    libffi \
    libxml2 \
    libxslt \
    openssh-client \
    python \
    py-boto \
    py-dateutil \
    py-httplib2 \
    py-jinja2 \
    py-paramiko \
    py-yaml \
# ***********************************************************
# The following are installed to allow use of pip and 
#  installation of ncclient and ansible
# 
# ncclient is required for NETCONF connections that are
#  used in network modules
# ***********************************************************
    build-base \
    libffi-dev \
    libxml2-dev \
    libxslt-dev \
    openssl-dev \
    py-pip \
    py-setuptools \
    python-dev && \
# ***********************************************************
# end temporary packages
# ***********************************************************
  pip install --upgrade pip python-keyczar && \
  pip install ncclient && \
  pip install ansible && \
# ***********************************************************
# Remove "stuff" we don't need any more
# ***********************************************************
  apk del \
    build-base \
    libffi-dev \
    libxml2-dev \
    libxslt-dev \
    openssl-dev \
    py-pip \
    py-setuptools \
    python-dev && \
  rm -rf /var/cache/apk/* && \
# ***********************************************************
# end removal of temporary "stuff"
# ***********************************************************
# Now setup Ansible "stuff"
# ***********************************************************
  mkdir /etc/ansible/ /ansible /ansible/playbooks && \
  echo "[local]" >> /etc/ansible/hosts && \
  echo "localhost" >> /etc/ansible/hosts && \
  adduser -D -u 1001 ansible -s /bin/bash && \
  chmod 777 /home/ansible

WORKDIR /ansible/playbooks

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING False
ENV ANSIBLE_RETRY_FILES_ENABLED False
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True

ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

ENV HOME /home/ansible
