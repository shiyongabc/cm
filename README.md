# 1 ��ȡ����(�����ڰ���cm��tar.gz�ļ���cdh��parcel-repo)
```
docker pull registry.cn-shenzhen.aliyuncs.com/xuybin/cm
```
### �����ߵ��뾵�� 
```
docker save registry.cn-shenzhen.aliyuncs.com/xuybin/cm > cm.tar
docker load < cm.tar
```
### ���нڵ�
```
echo -e '
Host *
UserKnownHostsFile /dev/null
StrictHostKeyChecking no
LogLevel quiet
'>/root/.ssh/config
```

# 2 �༭��Ⱥ�ڵ�ip��hostname��,����ִ��
```
wget https://raw.githubusercontent.com/xuybin/cm/master/cm.sh && chmod +x cm.sh
nano cm.sh
./cm.sh pwd1 pwd2 ...
```

# 3 �������ڵ�cloudera-scm-server��Ҫ��mysql���ݿ�
```
cat /var/log/mysqld.log | grep password
mysql_secure_installation
[...]
Enter current password for root (enter for none):
OK, successfully used password, moving on...
[...]
Set root password? [Y/n] y
New password:
Re-enter new password:
Remove anonymous users? [Y/n] Y
[...]
Disallow root login remotely? [Y/n] N
[...]
Remove test database and access to it [Y/n] Y
[...]
Reload privilege tables now? [Y/n] Y
All done!

mysql -uroot -p
mysql> SELECT DISTINCT CONCAT('User: ''',user,'''@''',host,''';') AS query FROM mysql.user;
+------------------------------------+
| query                              |
+------------------------------------+
| User: 'mysql.session'@'localhost'; |
| User: 'mysql.sys'@'localhost';     |
| User: 'root'@'localhost';          |
+------------------------------------+
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
mysql> show variables like "character%";
+--------------------------+----------------------------+
| Variable_name            | Value                      |
+--------------------------+----------------------------+
| character_set_client     | utf8                       |
| character_set_connection | utf8                       |
| character_set_database   | utf8                       |
| character_set_filesystem | binary                     |
| character_set_results    | utf8                       |
| character_set_server     | utf8                       |
| character_set_system     | utf8                       |
| character_sets_dir       | /usr/share/mysql/charsets/ |
+--------------------------+----------------------------+

mysql> create database hive DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

mysql> create database amon DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

mysql> exit

/opt/cm-5.5.0/share/cmf/schema/scm_prepare_database.sh mysql scm���ݿ� scm���ݿ��û��� scm���� -u���д���Ȩ�޵�mysql�û��� -p���д���Ȩ�޵�mysql�û�����

mysql -uroot -p
mysql> SELECT DISTINCT CONCAT('User: ''',user,'''@''',host,''';') AS query FROM mysql.user;
+------------------------------------+
| query                              |
+------------------------------------+
| User: 'mysql.session'@'localhost'; |
| User: 'mysql.sys'@'localhost';     |
| User: 'root'@'localhost';          |
| User: 'scm'@'localhost';           |
+------------------------------------+

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| amon               |
| hive               |
| mysql              |
| performance_schema |
| scm                |
| sys                |
+--------------------+

mysql> exit

```

# 4 ����
### ���ڵ�����cloudera-scm-server���鿴��־
```
systemctl restart cloudera-scm-server
systemctl status cloudera-scm-server
systemctl enable cloudera-scm-server
tail -f /opt/cm-5.5.0/log/cloudera-scm-server/cloudera-scm-server.log
```
### ���нڵ�����cloudera-scm-agent���鿴��־
```
systemctl restart cloudera-scm-agent
systemctl status cloudera-scm-agent
systemctl enable cloudera-scm-agent
tail -f /opt/cm-5.5.0/log/cloudera-scm-agent/cloudera-scm-agent.log
```
# 5 ʹ��admin:admin��½http://���ڵ�:7180/
ѡ�� parcelsģʽ,����·�� /opt/cloudera/parcel-repo

# 6 ��װʧ�ܻ���װ����
```
systemctl stop cloudera-scm-agent &&  systemctl disable cloudera-scm-agent && systemctl stop cloudera-scm-server &&  systemctl disable cloudera-scm-server

rpm -qa |grep cloudera |xargs yum remove -y
rpm -qa |grep postgresql |xargs yum remove -y 
rpm -qa |grep oracle-j2sdk |xargs yum remove -y
rpm -qa |grep mysql |xargs yum remove -y && rm -rf /etc/mysql /var/lib/mysql /var/cache/yum/x86_64/7/mysql* /var/lib/yum/repos/x86_64/7/mysql* /var/log/mysqld.log
ps -ef |grep /opt/cm-5.5.0/
kill -9 ***
rm -rf /etc/init.d/cloudera-* /etc/default/cloudera-* /etc/yum.repos.d/cloudera* && yum clean all && rm -rf /var/cache/yum/yum/x86_64/7/cloudera* /var/lib/yum/repos/x86_64/7/cloudera* /var/cache/yum/x86_64/7/cloudera-*
rm -rf /opt/cm-* /usr/share/cmf /var/lib/cloudera* /var/cache/yum/x86_64/6/cloudera* /var/log/cloudera* /var/run/cloudera* /etc/cloudera* /opt/cloudera*  /etc/rc.d/rc0.d/K10cloudera-* /etc/rc.d/init.d/cloudera* /tmp/*  
cd /etc/rc.d/rc1.d/ && rm -rf K10cloudera-scm-agent K10cloudera-scm-server
cd /etc/rc.d/rc2.d/ && rm -rf K10cloudera-scm-agent K10cloudera-scm-server
cd /etc/rc.d/rc3.d/ && rm -rf K10cloudera-scm-agent K10cloudera-scm-server
cd /etc/rc.d/rc4.d/ && rm -rf K10cloudera-scm-agent K10cloudera-scm-server
cd /etc/rc.d/rc5.d/ && rm -rf K10cloudera-scm-agent K10cloudera-scm-server
cd /etc/rc.d/rc6.d/ && rm -rf K10cloudera-scm-agent K10cloudera-scm-server
find / -path *cloudera*
find / -path *cm-5.5.0*
```