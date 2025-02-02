[root@ ~]# cat /u01/backup/script/backup.sh
#!/bin/bash

# Set the directories to be backed up
backup_dirs=(
"/data/CRM-PROXY"
"/data/statistic_vn"
"/data/Connector"
"/data/sms"
"/opt/tomcat/business.vn_apps"
"/opt/tomcat/cpsp_apps"
"/opt/tomcat/crm.vn_apps"
"/opt/tomcat/partner.vn_apps"
"/opt/tomcat/partner.vn_apps"
"/opt/tomcat/report.vn_apps"
"/opt/tomcat/webapps/view360"
"/etc/nginx"

)

# Set the backup filename and location
backup_file="/u01/backup/file/backup_$(date +%Y%m%d_%H%M%S).tar.gz"

# Create the backup archive
tar -czvf "$backup_file" "${backup_dirs[@]}"

# Print a message indicating whether the backup was successful
if [ -f "$backup_file" ]; then
  echo "Backup of ${backup_dirs[@]} completed successfully. Backup file: $backup_file"
else
  echo "Backup of ${backup_dirs[@]} failed!"
fi
