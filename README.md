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
 ansible-playbook --flush-cache -i /df/ansible-hadoop/hosts /df/ansible-hadoop/hadoop_install.yml
```


# Util
## Dfs Test
* s1에서 실행
```
hadoop fs -ls /
echo "hi" > a.txt
hadoop fs -mkdir -p /data     # 먼저 /data 디렉토리가 없다면 생성
hadoop fs -put a.txt /data    # 로컬 파일을 HDFS로 복사
hadoop fs -ls /data
```


`README.md` 파일의 `start/stop` 섹션에 `YARN` 관련 명령어를 추가하여 `ResourceManager`와 `NodeManager`도 함께 시작하고 종료할 수 있도록 업데이트하면 다음과 같음.

## Map/Reduce Test
* s1에서 실행
```
cd /df
mkdir -p wordcount_classes
javac -classpath $(hadoop classpath) -d wordcount_classes WordCount.java
jar -cvf WordCount.jar -C wordcount_classes/ .

hdfs dfs -mkdir -p /user/hadoop/input
hdfs dfs -put input.txt /user/hadoop/input/


#hdfs dfs -rm -r /user/hadoop/output
hadoop jar WordCount.jar WordCount /user/hadoop/input /user/hadoop/output


hdfs dfs -cat /user/hadoop/output/part-r-00000

```

## Start/Stop
* i1에서 실행
### Start all node
```bash
# HDFS 데몬 시작
ansible namenodes -i /df/ansible-hadoop/hosts -m shell -a "nohup hdfs --daemon start namenode &" -u root
ansible datanodes -i /df/ansible-hadoop/hosts -m shell -a "nohup hdfs --daemon start datanode &" -u root

# YARN 데몬 시작
ansible namenodes -i /df/ansible-hadoop/hosts -m shell -a "nohup yarn --daemon start resourcemanager &" -u root
ansible datanodes -i /df/ansible-hadoop/hosts -m shell -a "nohup yarn --daemon start nodemanager &" -u root

# MapReduce HistoryServer 시작 (선택 사항)
ansible namenodes -i /df/ansible-hadoop/hosts -m shell -a "nohup mapred --daemon start historyserver &" -u root
```

### Stop all node
```bash
# HDFS 데몬 종료
ansible namenodes -i /df/ansible-hadoop/hosts -m shell -a "hdfs --daemon stop namenode" -u root
ansible datanodes -i /df/ansible-hadoop/hosts -m shell -a "hdfs --daemon stop datanode" -u root

# YARN 데몬 종료
ansible namenodes -i /df/ansible-hadoop/hosts -m shell -a "yarn --daemon stop resourcemanager" -u root
ansible datanodes -i /df/ansible-hadoop/hosts -m shell -a "yarn --daemon stop nodemanager" -u root

# MapReduce HistoryServer 종료 (선택 사항)
ansible namenodes -i /df/ansible-hadoop/hosts -m shell -a "mapred --daemon stop historyserver" -u root
```

