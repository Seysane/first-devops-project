# Lesson 16

This section documents exercise 2 from lesson 16

---

### Exercise 2: Database administration and security


#### Exercise requirements:

* Create 3 user roles (admin,dev,auditor)
* Grant new user roles privileges
* Test new 3 user roles

#### Backup requirements:

* Create full copy of database from exercise 1
* Recreate this database on another name and check ingertity
* Create bash script that automates backups of this database with timestamp

#### Monitoring requirements:

* Check MySQL (postgresql), check active connections (SHOW PROCESSLIST)
* Display informations about tables (SHOW TABLE STATUS) 

#### Documentation requirements:

* Create DB_ADMIN.md (this file)
* Describe user roles, backup process, basics of monitoring

---

#### User privileges

| User | Privileges |
|------|------------|
| admin_user | SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER |
| dev_user | SELECT, INSERT, UPDATE |
| auditor_user | SELECT |


#### User tests

##### auditor_user

Testing auditor role with SELECT

```bash
sane@power-sane:~$ psql -U auditor_user -d blog_db -h localhost
Password for user auditor_user: 
psql (16.14 (Ubuntu 16.14-0ubuntu0.24.04.1))
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, compression: off)
Type "help" for help.

blog_db=> SELECT * FROM categories;
 id |    name     
----+-------------
  1 | Technology
  2 | Cooking
  3 | Traveling
  4 | Sport
(4 rows)
```
Testing auditor role with INSERT

```bash
blog_db=> INSERT INTO categories (name) VALUES ('Test');
ERROR:  permission denied for table categories
```

Everything works.

##### dev_user

Testing dev role with SELECT

```bash
sane@power-sane:~$ psql -U dev_user -d blog_db -h localhost
Password for user dev_user: 
psql (16.14 (Ubuntu 16.14-0ubuntu0.24.04.1))
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, compression: off)
Type "help" for help.

blog_db=> SELECT * FROM categories;
 id |    name     
----+-------------
  1 | Technology
  2 | Cooking
  3 | Traveling
  4 | Sport
(4 rows)
```

Testing dev role with INSERT

```bash
blog_db=> INSERT INTO categories (name) VALUES ('Test');
INSERT 0 1
blog_db=> DELETE FROM categories WHERE name = 'Test';
ERROR:  permission denied for table categories
blog_db=>
```

Everything works.

##### admin_user

Im not testing this role its superuser with all privileges.


#### Creating Database backup

To create db backup I used command `pg_dump`

```bash
sane@power-sane:~$ pg_dump -U postgres -h localhost blog_db > ~/blog_backup.sql
Password: 
sane@power-sane:~$ ls -lh ~/blog_backup.sql
-rw-rw-r-- 1 sane sane 16K Jul 13 14:16 /home/sane/blog_backup.sql
```

##### Creating database

To create new database I used

```bash
sane@power-sane:~$ psql -U postgres -h localhost -c "CREATE DATABASE blog_backup;"
Password for user postgres: 
CREATE DATABASE
```

To load backup to new database I used:

```bash
sane@power-sane:~$ psql -U postgres -h localhost blog_backup < ~/blog_backup.sql
Password for user postgres: 
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER SEQUENCE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER SEQUENCE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER SEQUENCE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE VIEW
ALTER VIEW
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER SEQUENCE
ALTER SEQUENCE
CREATE SEQUENCE
ALTER SEQUENCE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
COPY 5
COPY 5
COPY 7
COPY 5
COPY 5
COPY 3
 setval 
--------
      5
(1 row)

 setval 
--------
      5
(1 row)

 setval 
--------
      5
(1 row)

 setval 
--------
      5
(1 row)

 setval 
--------
      4
(1 row)

ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
```

For testing I used:

```bash
sane@power-sane:~$ psql -U postgres -h localhost blog_backup -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';"
Password for user postgres: 
        table_name        
--------------------------
 tags
 posts_with_comment_count
 posts
 comments
 users
 post_tags
 categories
(7 rows)
```

#### Automated backup with bash script

I made simple script `backup_db.sh` where I assigned:

`DB_NAME` - name of our database from exercise 1.
`BACKUP_DIR` - directory where backups will be saved.
`TIMESTAMP` - timestamp assigned for shortcut.
`BACKUP_FILE` - complex file creation

Then Im checking if backup dir exists, if not it creates one.

Next step user gets message that informs about creating database backup file, then we simply use pg_dump command to create the database backup, and again user gets message if it ended with `$BACKUP_FILE` information.

#### Database monitoring

To check postgresql active connections I used query (substitute for MySQL SHOW PROCESSLIST):

```text
SELECT pid, usename, datname, client_addr, state, query 
FROM pg_stat_activity 
WHERE state != 'idle';
```

| pid | usename | datname | client_addr | state | query |
| --- | --- | --- | --- | --- | --- |
| 10819 | postgres | blog_db | 127.0.0.1 | active | SELECT, pid, usename, datname, client_addr, state, query |

To check informations about tables I used query (substitute for MySQL SHOW TABLE STATUS):

```text
SELECT 
    relname AS table_name,
    n_live_tup AS estimated_rows,
    pg_size_pretty(pg_total_relation_size(relid)) AS total_size,
    pg_size_pretty(pg_relation_size(relid)) AS table_size,
    pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid)) AS index_size
FROM pg_stat_user_tables
ORDER BY pg_total_relation_size(relid) DESC;
```