# Find out SQL server version
```sql
SELECT @@VERSION
```

# Show all DB files sizes
```sql
SELECT DB_NAME(database_id) AS Database_Name, Name AS File_Name, Physical_Name AS Physical_Path, (size*8)/1024 Size_MB 
FROM sys.master_files order by Size_MB desc
```

# Reindex DB (MANDATORY if you shrink log files or DB)
```sql
EXEC sp_MSforeachtable 'dbcc dbreindex("?")'
```


# Show DBs with exceptional compatibility level
```sql
select name as 'DB name' 
       ,compatibility_level as 'DB compatibility'
       , 'Server version' = (select cmptlevel from master.dbo.sysdatabases where name = db_name() ) 
from sys.databases 
where compatibility_level not in (select cmptlevel from master.dbo.sysdatabases where name = db_name() )
```


# Fix the error 'User Group or Role Already Exists in the Current Database'

```sql
sp_change_users_login 'AUTO_FIX', 'someuser'
```
