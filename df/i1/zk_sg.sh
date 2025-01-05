#!/bin/bash

# Root Directory
BASE_DIR="/df/ansible-kafka"
mkdir -p $BASE_DIR

# Create directory structure
mkdir -p $BASE_DIR/roles/kafka/tasks
mkdir -p $BASE_DIR/roles/kafka/templates

# Create kafka_install.yml
cat << 'EOF' > $BASE_DIR/kafka_install.yml
- name: Install and Configure Kafka
  hosts: all
  become: yes
  tasks:
    - include_role:
        name: kafka
EOF

# Create hosts file
cat << 'EOF' > $BASE_DIR/hosts
[all]
s1
s2
s3
[consumer]
s1 ansible_connection=ssh ansible_user=root
s2 ansible_connection=ssh ansible_user=root
s3 ansible_connection=ssh ansible_user=root
EOF

# Create main.yml for Kafka role
cat << 'EOF' > $BASE_DIR/roles/kafka/tasks/main.yml
- include_tasks: install_kafka.yml
- include_tasks: configure_kafka.yml
EOF

# Create install_kafka.yml
cat << 'EOF' > $BASE_DIR/roles/kafka/tasks/install_kafka.yml
- name: Download Kafka
  ansible.builtin.get_url:
    url: https://dlcdn.apache.org/kafka/3.9.0/kafka_2.12-3.9.0.tgz
    dest: /df/kafka_2.12-3.9.0.tgz

- name: Extract Kafka
  ansible.builtin.unarchive:
    src: /df/kafka_2.12-3.9.0.tgz
    dest: /opt/
    remote_src: yes

- name: Rename Kafka Directory
  ansible.builtin.command:
    cmd: mv /opt/kafka_2.12-3.9.0 /opt/kafka
    creates: /opt/kafka
EOF

# Create configure_kafka.yml
cat << 'EOF' > $BASE_DIR/roles/kafka/tasks/configure_kafka.yml
- name: Update PATH in bashrc
  ansible.builtin.lineinfile:
    path: /etc/bashrc
    line: 'export PATH=$PATH:/opt/kafka/bin'
    state: present

- name: Configure Zookeeper properties
  ansible.builtin.blockinfile:
    path: /opt/kafka/config/zookeeper.properties
    block: |
      initLimit=10
      syncLimit=5
      server.1=s1:2888:3888
      server.2=s2:2888:3888
      server.3=s3:2888:3888
    state: present

- name: Ensure /data/zookeeper directory exists
  ansible.builtin.file:
    path: /data/zookeeper
    state: directory
    owner: root
    group: root
    mode: '0755'

- name: Configure Kafka server properties
  ansible.builtin.lineinfile:
    path: /opt/kafka/config/server.properties
    line: "zookeeper.connect=s1:2181,s2:2181,s3:2181"
    state: present
EOF

# Completion Message
echo "Ansible Kafka Playbook files and directory structure created in $BASE_DIR"
echo "To execute the playbook, run: ansible-playbook -i $BASE_DIR/hosts $BASE_DIR/kafka_install.yml -e ansible_python_interpreter=/usr/bin/python3.12"
