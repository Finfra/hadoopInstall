# hadoop_clusterInstall
Hadoop cluster install on ubuntu docker
* 주의 : 하둡파일(https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz)이 df/i1에 있어야 작동함.

# install
## Container Install
```
git clone git@github.com:Finfra/hadoopInstall.git
cd hadoopInstall
. do.sh
```
## Hadoop Install by Ansible
```
ansible-playbook -i /df/ansible-hadoop/hosts /df/ansible-hadoop/hadoop_install.yml

```
