> Commands are not for sure, for sure - MySQL could be MariaDB etc.

> **BACKUP CONFIGS!** `cp <orig> <orig>.bak`
#### MySQL - Assuming MySQL on centos?
- [!] **DO NOT ALLOW TABLES TO BE DROPPED**
	- Especially for scored services
- [!] **CHANGE root pass**
- [!] Disable remote root login
- [!] Audit users and perms - **REGULARLY**
- [!] Secure MySQL conf files
	- `chown root:root /etc/my.cnf`
	- `chmod 644 /etc/my.cnf`
- [!] Enable **ERROR LOGGING** and check it **REGULARLY**
	- Add to my.cnf: `log-error=/var/log/mysql/error.log`
- [b] Run secure MySQL/MariaDB install 
	- `sudo mysql_secure_installation`
- [b] Make sure MySQL is up to date
- [i] Set file perms for data directory
	- `chown -R mysql:mysql /var/lib/mysql`
	- `chmod -R 750 /var/lib/mysql/
- [i] Enable general query log for auditing - can be resource intensive
	- Add to my.cnf: `general_log=1` and `general_log_file=/var/log/mysql/query.log`
- [i] Backing up tables is an option, requires more research and work... ew
	- `sudo mariadb-dump -u root -p --all-databases` backups all
	- `sudo mariadb-dump -u root -p <db_name>`
	- `sudo mysql -u root -p <dump_file>.sql` adds dbs in file, if only one need to create db before running command

### Apache - Assuming CENTOS?
- [!] Make sure **ERROR LOGGING** and **ACCESS LOGS** are enabled
	- Edit log format: `LogFormat "%h %l %u %t "%{sessionID}C" "%r" %>s %b %T" common`
	- [READ MORE](http://httpd.apache.org/docs/2.2/mod/mod_log_config.html)
- [!] **Secure PHP**
	- [Secure php.ini file](https://github.com/danvau7/very-secure-php-ini)
	- [!] Ensure PHP is up to date
	- [READ MORE](https://cheatsheetseries.owasp.org/cheatsheets/PHP_Configuration_Cheat_Sheet.html)
- [b] Make sure Apache is up to date
- [i] Disable server tokens
	- Add to httpd.conf: `ServerTokens Prod` and `ServerSignature Off`
- [i] Disable unnecessary modules - 
	- View all enabled mods: `httpd -M` and using grep 
	- Comment out module lines in "/etc/httpd/conf.modules.d/00-base.conf" to disable unneeded module
	- [READ MORE](https://linuxblog.io/strip-apache-improve-performance-memory-efficiency/)
- [i] Mod Security - waf
	- Use mod_security and mod_evasive modules for apache/httpd
	- [READ MORE](https://linuxblog.io/strip-apache-improve-performance-memory-efficiency/)
- [i] Etag
	- Add to httpd.conf: `FileETag None`
- [i] Run Apache from non-privileged user i.e. make an apache user and group
	- [READ MORE](https://linuxblog.io/strip-apache-improve-performance-memory-efficiency/)
- [i] Protect binary and httpd.conf from other users 
	- `chmod -R 750 bin conf`?
- [i] Can blacklist all but one ip to admin pages
- [i] `wget https://raw.githubusercontent.com/LanodonF/Whitesand.5/refs/heads/main/webdb/httpd_hard.sh`
	- `chmod +x ./httpd_hard.sh`
	- `sudo ./httpd_hard.sh`

## NGINX - Assuming Ubuntu? 
- [!] Make sure **ERROR LOGGING** and **ACCESS LOGS** are enabled and **monitor**
	- Set level of logging to info `error_log /var/log/nginx/error.log info;`
- [!] Ensure nginx.conf loads correctly with no error `sudo nginx -t`
- [b] Make sure Nginx is up to date
- [i] Disable server tokens
	- Add to nginx.conf: `server_tokens: off;`
- [i] Run Nginx from non-privileged user i.e. make nginx user and edit conf
	- Add user: `sudo adduser nginxuser`
	- Add perms: `sudo chown -R nginxuser:nginxuser /var/log/nginx` 
	- Add perms: `sudo chown -R nginxuser:nginxuser /var/lib/nginx`
	- Edit nginx.conf: `user nginxuser;`
	- Could use www-data?
	- [READ MORE](https://www.geeksforgeeks.org/how-to-run-nginx-for-root-non-root/)
- [i] Hide proxy headers if php? - also secure php if php
- [i] Add secure headers - not really important
	- `add_header X-Frame-Options SAMEORIGIN;` - nginx.conf 
	- `add_header X-Content-Type-Options nosniff;` - |
	- `add_header X-XSS-Protection "1; mode=block";` - |
- [i] Mod Security - WAF
	- Download and configure
	- [READ MORE](https://modsecurity.org/)
	- [READ MORE](https://docs.nginx.com/nginx-waf/admin-guide/nginx-plus-modsecurity-waf-installation-logging/)
- [i] Remove unnessecary modules
	- Requires research into what is used and what is not being used at all
- [i] Can blacklist all but one ip to admin pages if they exist?
- [i] Limit requests to 500 per second per ip
	- `limit_req_zone $binary_remote_addr zone=allips:10m rate= 500r/s;` - nginx.conf
	- `limit_req zone=allips burst=400 nodelay;` - |
- [b] `sudo nginx -s reload` reloads nginx.conf quickly?

#### Windows IIS - IDK
- [!] Make sure logging and monitor logs
- [b] Make sure up to date?
- [i] Idk make sure score is posting, can't find relevant information.

##### Email Software - Unknown?
- [!] pray one of the injects is not migrating the email server to something else .\_.
- [!] Logging and monitor logs
- [!] Audit users
- [b] I... don't know
- [i] hMail sucks major balls security wise

###### General Notes
- Master Pass no good?
- Find scoring engine ip
- Find malicious ips?
- This not going to go well