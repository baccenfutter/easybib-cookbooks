# install a cronjob to run every 5 minutes

if node[:opsworks][:instance][:layers].include?('bibapi')
  cron "stats from redis to mysql" do
    mailto node[:sysop_email]
    minute "*/5"
    command "/usr/local/bin/php /srv/www/easybib_api/current/app/modules/default/scripts/cron_tracking_into_mysql.php"
  end
end
