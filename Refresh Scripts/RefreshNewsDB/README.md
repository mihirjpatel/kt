The execution file was created from ps1 file using PS2EXE -- https://gallery.technet.microsoft.com/PS2EXE-Convert-PowerShell-9e4e07f1

Prerequisites:
1. .Net
2. Add mysql.exe path to enviornment variables


Refresh .COM
1. Make sure Backup Files is in C:\wordpress.sql  -- File SHOULD NOT contain CREATE and USE DB
2. Execute exe File
3. Enter Environment Name
	a. Dev
	b. QA
	c. Staging
	d. Test (This will Create a Test Database and import data.  Be sure to drop database after test).


Refresh .CN
1. Make sure Backup Files is in C:\wordpress_cn.sql  -- File SHOULD NOT contain CREATE and USE DB
2. Execute exe File
3. Enter Environment Name
	a. Dev-CN
	b. QA-CN
	c. Staging-CN
	d. Test-CN (This will Create a Test Database and import data.  Be sure to drop database after test).


Notes:
Version 1.0
RefreshNewsDB.cnf contains host, username, and password
The powershell script is hardcoded with database names based on Environments (wordpress_dev, wordpress_qa, wordpress, test).