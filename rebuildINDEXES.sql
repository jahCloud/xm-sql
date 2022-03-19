Rebuild all indexes on selected databases
/*rebuild all indexes*/
/*from the XMPDB2 stored procedure: SP_CleanupAndMaintain*/
RAISERROR('Status: rebuilding indexes

',0,1) WITH NOWAIT
DECLARE @affectedRows bigint
DECLARE @affectedRowsTemp bigint
DECLARE @Database NVARCHAR(255)
DECLARE @Table NVARCHAR(255)
DECLARE @cmd NVARCHAR(1000)
SET @affectedRows = 0
DECLARE DatabaseCursor CURSOR READ_ONLY FOR
SELECT name FROM master.sys.databases
-- Change the following array to fit the list of databases to reindex
WHERE name IN ('XMPDB2', 'XMPDBASSETS', 'XMPDBHDS', 'uStore')
OPEN DatabaseCursor
FETCH NEXT FROM DatabaseCursor INTO @Database
WHILE @@FETCH_STATUS = 0
BEGIN
RAISERROR('%s:',0,1,@Database) WITH NOWAIT
RAISERROR('Rebuilding indexes',0,1,@Database) WITH NOWAIT
SET @affectedRowsTemp = 0
SET @cmd = 'DECLARE TableCursor CURSOR READ_ONLY FOR SELECT ''['' + table_catalog + ''].['' + table_schema + ''].['' + table_name + '']'' as tableName FROM [' + @Database + '].INFORMATION_SCHEMA.TABLES WHERE table_type = ''BASE TABLE'' AND table_schema = ''XMPie'''
EXEC (@cmd)
OPEN TableCursor
FETCH NEXT FROM TableCursor INTO @Table
WHILE @@FETCH_STATUS = 0
BEGIN
SET @affectedRowsTemp = @affectedRowsTemp + 1
SET @affectedRows = @affectedRows + 1
SET @cmd = 'ALTER INDEX ALL ON ' + @Table + ' REBUILD'
EXEC (@cmd)
FETCH NEXT FROM TableCursor INTO @Table
END
RAISERROR('%I64d indexes were rebuilt

',0,1,@affectedRowsTemp) WITH NOWAIT
CLOSE TableCursor
DEALLOCATE TableCursor
FETCH NEXT FROM DatabaseCursor INTO @Database
END
CLOSE DatabaseCursor
DEALLOCATE DatabaseCursor
RAISERROR('Message: %I64d indexes were rebuilt',0,1,@affectedRows) WITH NOWAIT
