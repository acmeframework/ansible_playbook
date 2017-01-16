FROM gliderlabs/alpine:3.4

RUN \
  apk-install \
    bash \
    curl \
    openssh-client \
    python \
    py-boto \
    py-dateutil \
    py-httplib2 \
    py-jinja2 \
    py-paramiko \
    py-pip \
    py-setuptools \
    py-yaml \
    tar && \
  pip install --upgrade pip python-keyczar && \
  pip install ansible==2.2.0.0 && \
  rm -rf /var/cache/apk/*

RUN mkdir /etc/ansible/ /ansible /ansible/playbooks
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts && \
    adduser -D -u 1001 ansible -s /bin/bash && \
    chmod 777 /home/ansible

WORKDIR /ansible/playbooks

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING False
ENV ANSIBLE_RETRY_FILES_ENABLED False
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV HOME /home/ansible
