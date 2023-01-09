# create a docker yml file: docker-compose.yml

version: '3'
services:
  mysql_primary:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root_password_test
      MYSQL_DATABASE: mydb
    container_name: "mysql_primary"
    ports:
      - "3306:3306"
    volumes:
      - ./master/conf/mysql.cnf:/etc/mysql/conf.d/mysql.conf.cnf
      - ./master/data:/var/lib/mysql
    networks:
      - overlay      
  mysql_replica:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root_password_test
      MYSQL_DATABASE: mydb
    container_name: "mysql_replica"
    ports:
      - "3307:3306"
    depends_on:
      - mysql_primary
    volumes:
      - ./slave/conf/mysql.cnf:/etc/mysql/conf.d/mysql.conf.cnf
      - ./slave/data:/var/lib/mysql
    networks:
      - overlay

networks:
  overlay:

# create dir for master
mkdir -p master/conf/
mkdir -p master/data/

vim mysql.cnf
[mysqld]
skip-name-resolve
default_authentication_plugin = mysql_native_password
server-id = 1
log_bin = 1
binlog_format = ROW

# create dir for slave
mkdir -p slave/conf/
mkdir -p slave/data/

vim mysql.cnf
[mysqld]
skip-name-resolve
default_authentication_plugin = mysql_native_password
server-id = 2
log_bin = 1
binlog_format = ROW
  
# save file and run below command
docker-compose up -d

# check docker
docker ps
# docker ps
CONTAINER ID   IMAGE       COMMAND                  CREATED          STATUS          PORTS                                                  NAMES
fe0af9d08647   mysql:8.0   "docker-entrypoint.s…"   11 seconds ago   Up 4 seconds    33060/tcp, 0.0.0.0:3307->3306/tcp, :::3307->3306/tcp   mysql_replica
e5876afa9b16   mysql:8.0   "docker-entrypoint.s…"   16 seconds ago   Up 10 seconds   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp   mysql_primary

# connect to the primary:
docker exec -it mysql_primary mysql -u root -p

# create replication user
CREATE USER "mydb_repl_user"@"%" IDENTIFIED BY "mydb_repl_pwd"; 
GRANT REPLICATION SLAVE ON *.* TO "mydb_repl_user"@"%"; 
FLUSH PRIVILEGES;

SHOW MASTER STATUS\G
*************************** 1. row ***************************
             File: 1.000003
         Position: 847
 Binlog_Ignore_DB: 
Executed_Gtid_Set: 

# run below sql command for test replication:

USE mydb;
CREATE TABLE table_test (id INT);
INSERT INTO table_test VALUES (1);

select * from table_test;
+------+
| id   |
+------+
|    1 |
+------+

# checking data in replica
docker exec -it mysql_replica mysql -u root -p

RESET MASTER;
STOP SLAVE;

CHANGE MASTER TO 
MASTER_HOST='mysql_primary',
MASTER_USER='mydb_repl_user',
MASTER_PASSWORD='mydb_repl_pwd',
MASTER_LOG_FILE='1.000003',
MASTER_LOG_POS=847; 

START SLAVE;

show slave status\G

USE mydb;
select * from table_test;
