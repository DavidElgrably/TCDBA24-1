----------- 23 Backup and Restore -----------
--- 1 ---
USE [master] ;  
ALTER DATABASE [eDate] SET RECOVERY FULL ; 
BACKUP DATABASE [eDate] TO  DISK = N'C:\CourseMaterials\eDate\BackupFiles\eDate_Full.bak' WITH  DESCRIPTION = N'eDate-Full ', NOFORMAT, NOINIT,  NAME = N'eDate-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'eDate' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'eDate' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for database ''eDate'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N'C:\CourseMaterials\eDate\BackupFiles\eDate_Full.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO

--- 2 ---
use eDate
insert into Operation.Members
values
('karina_b',	1087743, 'K', 'B'	,NULL	,2	,NULL	,'xxxxxxxxxx@gmail.com'	,2	,'1996-11-08'	,NULL	,1	,NULL	,'2017-09-17 09:43:40')

--- 3 ---
BACKUP DATABASE [eDate] TO  DISK = N'C:\CourseMaterials\eDate\BackupFiles\eDate_Full.bak' WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N'eDate-Diff Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

--- 4 ---
use eDate
insert into Operation.Members
values
('XXXXXX',	1087743, 'K', 'B'	,NULL	,2	,NULL	,'xxxxxxxxxx@gmail.com'	,2	,'1996-11-08'	,NULL	,1	,NULL	,'2017-09-17 09:43:40')

--- 5 ---

BACKUP LOG [eDate] TO  DISK = N'C:\CourseMaterials\eDate\BackupFiles\eDate_TLog.trn' WITH NOFORMAT, NOINIT,  NAME = N'eDate-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

--- 6 ---
use eDate
insert into Operation.Members
values
('XXXXXX',	111222333, 'L', 'M'	,NULL	,2	,NULL	,'xxxxxxxxxx@gmail.com'	,2	,'1996-11-08'	,NULL	,1	,NULL	,'2017-09-17 09:43:40')

--- 7 ---
use master
ALTER DATABASE [eDate] SET SINGLE_USER
RESTORE DATABASE [eDate] FROM  DISK = N'C:\CourseMaterials\eDate\BackupFiles\eDate_Full.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 5

--- 8 ---
--- We will not have access as we in No recovery mode

--- 9 ---
use master
RESTORE DATABASE [eDate] FROM  DISK = N'C:\CourseMaterials\eDate\BackupFiles\eDate_Full.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  REPLACE,  STATS = 5
RESTORE DATABASE [eDate] FROM  DISK = N'C:\CourseMaterials\eDate\BackupFiles\eDate_Full.bak' WITH  FILE = 2,  STANDBY = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\eDate_RollbackUndo_2018-12-18_16-19-13.bak',  NOUNLOAD,  STATS = 5

--- 10 ---
use eDate
select *
from operation.members
---- Insert will not work since we are in Standby mode
insert into Operation.Members
values
('XXXXXX',	1087743, 'K', 'B'	,NULL	,2	,NULL	,'xxxxxxxxxx@gmail.com'	,2	,'1996-11-08'	,NULL	,1	,NULL	,'2017-09-17 09:43:40')

--- 11 ---
use master
RESTORE DATABASE [eDate] FROM  DISK = N'C:\CourseMaterials\eDate\BackupFiles\eDate_Full.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  REPLACE,  STATS = 5
RESTORE DATABASE [eDate] FROM  DISK = N'C:\CourseMaterials\eDate\BackupFiles\eDate_Full.bak' WITH  FILE = 2,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [eDate] FROM  DISK = N'C:\CourseMaterials\eDate\BackupFiles\eDate_TLog.trn' WITH  FILE = 1,  STANDBY = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\eDate_RollbackUndo_2018-12-18_16-24-18.bak',  NOUNLOAD,  STATS = 5

--- 12 ---
use eDate
select *
from operation.members
--- We restored the the DB after 2 inserts so it will be 100002

--- 13 ---
use master
RESTORE DATABASE eDate

--- 14 ---

CREATE DATABASE eDate_Snapshot_1
ON
(
NAME =eDate_Data,
FILENAME ='C:\CourseMaterials\eDate\BackupFiles\eDate_Snapshot_1.SS'
)
AS SNAPSHOT OF eDate

--- 15 ---

--select @@VERSION

--Microsoft SQL Server 2016 (SP1-CU5) (KB4040714) - 13.0.4451.0 (X64)   Sep  5 2017 16:12:34   Copyright (c) Microsoft Corporation  Enterprise Edition (64-bit) on Windows Server 2012 R2 Standard 6.3 <X64> (Build 9600: ) (Hypervisor) 


USE eDate ;  
GO  
EXEC sp_addumpdevice 'disk', 'Backup_device', 'C:\backup\eDate.bak'
EXEC sp_addumpdevice 'disk', 'Backup_device_2', 'C:\CourseMaterials\eDate.bak' ;  
GO  

BACKUP DATABASE [eDate] TO  [Backup_device],  [Backup_device_2] WITH NOFORMAT, NOINIT,  NAME = N'eDate-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10


