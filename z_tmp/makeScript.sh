#!/bin/bash

# 디렉터리 생성
mkdir -p ansible-hadoop/roles/hadoop/{tasks,templates}

# hadoop_install.yml 생성
cat << 'EOF' > df/i1/ansible-hadoop/hadoop_install.yml
- name: Hadoop Installation Playbook
  hosts: hadoop_cluster
  become: yes
  roles:
    - hadoop
EOF



# Inventory 생성
cat > ansible-hadoop/hosts<<EOF
[hadoop_cluster]
s1 ansible_user=root
s2 ansible_user=root
s3 ansible_user=root
EOF

# main.yml
cat << 'EOF' > df/i1/ansible-hadoop/roles/hadoop/tasks/main.yml
- import_tasks: install_java.yml
- import_tasks: download_hadoop.yml
- import_tasks: configure_hadoop.yml
- import_tasks: configure_java.yml
EOF

# roles/hadoop/tasks/install_java.yml 생성
cat << 'EOF' > df/i1/ansible-hadoop/roles/hadoop/tasks/install_java.yml
- name: Install Java
  yum:
    name: java-1.8.0-openjdk
    state: present
EOF

# java 셋팅 
cat << 'EOF' > df/i1/ansible-hadoop/roles/hadoop/tasks/configure_java.yml
- name: Set JAVA_HOME in hadoop-env.sh
  lineinfile:
    path: /opt/hadoop/etc/hadoop/hadoop-env.sh
    line: 'export JAVA_HOME=/usr/lib/jvm/jre-openjdk'
    create: yes

- name: Set JAVA_HOME in ~/.bashrc
  lineinfile:
    path: ~/.bashrc
    line: 'export JAVA_HOME=/usr/lib/jvm/jre-openjdk'
    create: yes

- name: Apply .bashrc changes
  shell: source ~/.bashrc
  args:
    executable: /bin/bash
EOF

# roles/hadoop/tasks/download_hadoop.yml 생성
cat << 'EOF' > df/i1/ansible-hadoop/roles/hadoop/tasks/download_hadoop.yml
- name: Copy Hadoop from local
  copy:
    src: hadoop-3.3.6.tar.gz
    dest: /opt/hadoop.tar.gz

- name: Extract Hadoop
  unarchive:
    src: /opt/hadoop.tar.gz
    dest: /opt/
    remote_src: yes

- name: Create Hadoop symbolic link
  file:
    src: /opt/hadoop-3.3.6
    dest: /opt/hadoop
    state: link
EOF

# roles/hadoop/tasks/configure_hadoop.yml 생성
cat << 'EOF' > df/i1/ansible-hadoop/roles/hadoop/tasks/configure_hadoop.yml
- name: Configure core-site.xml
  template:
    src: core-site.xml.j2
    dest: /opt/hadoop/etc/hadoop/core-site.xml

- name: Configure hdfs-site.xml
  template:
    src: hdfs-site.xml.j2
    dest: /opt/hadoop/etc/hadoop/hdfs-site.xml

- name: Configure mapred-site.xml
  template:
    src: mapred-site.xml.j2
    dest: /opt/hadoop/etc/hadoop/mapred-site.xml

- name: Configure yarn-site.xml
  template:
    src: yarn-site.xml.j2
    dest: /opt/hadoop/etc/hadoop/yarn-site.xml
EOF


# 템플릿 파일 생성
cat << 'EOF' > df/i1/ansible-hadoop/roles/hadoop/templates/core-site.xml.j2
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://{{ ansible_hostname }}:9000</value>
    </property>
</configuration>
EOF

cat << 'EOF' > df/i1/ansible-hadoop/roles/hadoop/templates/hdfs-site.xml.j2
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>3</value>
    </property>
</configuration>
EOF

cat << 'EOF' > df/i1/ansible-hadoop/roles/hadoop/templates/mapred-site.xml.j2
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>
EOF

cat << 'EOF' > df/i1/ansible-hadoop/roles/hadoop/templates/yarn-site.xml.j2
<configuration>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>{{ ansible_hostname }}</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
</configuration>
EOF

echo "Ansible Hadoop 디렉터리와 파일이 모두 생성되었습니다."

