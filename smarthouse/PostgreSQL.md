# PostgreSQL Commands for macOS

## Installation

### Install PostgreSQL using Homebrew
1. Install
```bash
brew install postgresql
```

2. Start/ Stop PostgreSQL service

```bash
brew services start postgresql
```

```bash
brew services stop postgresql
```

3. estart PostgreSQL service

```bash
brew services restart postgresql
```

#### Basic Commands
1. Check PostgreSQL version
```bash
postgres -V
```

2. Access PostgreSQL shell (psql)

```bash
psql postgres
```

3. Exit the PostgreSQL shell

```bash
\q
```

4. Check running services
```bash
brew services list
```

#### Database Operations
1. List all databases
```sql
\l
```

2. Create a new database
```bash
createdb mydatabase
```

3. Drop a database
```bash
dropdb mydatabase
```

4. Connect to a specific database
```bash
psql mydatabase
```

5. Show tables in a database
```sql
\dt
```

6. Create a new table
```sql
CREATE TABLE mytable (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT
);
```

7. Insert data into a table
```sql
INSERT INTO mytable (name, age) VALUES ('Alice', 30);
```

8. Select data from a table
```sql
SELECT * FROM mytable;
```

9. Drop a table
```sql
DROP TABLE mytable;
```

10. Delete all datda
```sql
smart_house=# DELETE FROM actions;
DELETE 7
smart_house=# DELETE FROM events;
DELETE 13
smart_house=# DELETE FROM devices;
DELETE 33
smart_house=# DELETE FROM rooms;
DELETE 3
```

#### User Management
1. List all users
```sql
\du
```

2. Create a new user
```sql
CREATE USER myuser WITH PASSWORD 'mypassword';
```

3. Grant privileges to a user on a database
```sql
GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;
```

4. Change password for a user
```sql
ALTER USER myuser WITH PASSWORD 'newpassword';
```

5. Drop a user
```sql
DROP USER myuser;
```

#### Database Backup and Restore
1. Backup a database
```bash
pg_dump mydatabase > mydatabase_backup.sql
```

2. Restore a database from a backup
```bash
psql mydatabase < mydatabase_backup.sql
```

### Configuration and Logs
1. Edit PostgreSQL configuration file
```bash
nano /usr/local/var/postgres/postgresql.conf
```

2. View PostgreSQL logs
```bash
tail -f /usr/local/var/postgres/server.log
```

#### Miscellaneous
1. Display PostgreSQL environment info
```bash
psql -V
```

2. Show current connections
```sql
SELECT * FROM pg_stat_activity;
```

3. Kill a specific connection
```sql
SELECT pg_terminate_backend(pid);
```