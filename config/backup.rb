
# Backup Configuration File
#
# Use the "backup" block to add backup settings to the configuration file.
# The argument before the "do" in (backup "argument" do) is called a "trigger".
# This acts as the identifier for the configuration.
#
# In the example below we have a "mysql-backup-s3" trigger for the backup setting.
# All the configuration is done inside this block. To initialize the backup process for this block,
# you invoke it using the following rake task:
#
#   rake backup:run trigger="mysql-backup-s3"
#   http://wiki.github.com/meskyanichi/backup/configuration-file

# Notifier
#   Uncomment this if you want to enable notification by email on successful backup runs
#   You will also have to set "notify true" inside each backup block below to enable it for that particular backup
notifier_settings do

  to    ["servers@neotericdesign.com", "gj@restaurantintelligenceagency.com", "ellen@restaurantintelligenceagency.com"]
  from  "backups@restaurantintelligenceagency.com"

  smtp do
    host            "smtp.gmail.com"
    port            "587"
    username        "spoonfeed@neotericdesign.com"
    password        "5U8579"
    authentication  "plain"
    domain          "restaurantintelligenceagency.com"
    tls             true
  end

end


# Initialize with:
#   rake backup:run trigger='backup-db-to-s3'
backup 'backup-db-to-s3' do

  adapter :mysql2 do
    user        'ria_prod'
    password    'aEm05pI8Nne8'
    database    'ria_production'
  end

  storage :s3 do
    access_key_id     'AKIAILTU3LUR6KLQ2ODQ'
    secret_access_key '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'
    bucket            '/spoonfeed/production/backups/mysql'
    use_ssl           true
  end

  keep_backups 25
  encrypt_with_password false
  notify true
end


# Initialize with:
#   rake backup:run trigger='backup-files-to-s3'
backup 'backup-files-to-s3' do

  adapter :archive do
    files ["/home/ria/rails/shared/log", "/home/ria/rails/shared/system"]
  end

  storage :s3 do
    access_key_id     'AKIAILTU3LUR6KLQ2ODQ'
    secret_access_key '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'
    bucket            '/spoonfeed/production/backups/'
    use_ssl           true
  end

  keep_backups 15
  encrypt_with_password false
  notify false
end
