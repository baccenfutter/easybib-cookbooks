include_recipe 'ies::setup-basepackages'
include_recipe 'ies::setup-bibopsworks' if is_aws
include_recipe 'ies::nscd'
include_recipe 'ies::ruby-defaultgemrc'

if is_aws
  include_recipe 'ies::setup-syslog'
  include_recipe 'ies::setup-sns'
  include_recipe 'ies-route53::add'
  include_recipe 'fail2ban'
  include_recipe 'ies::opsworks-fixes'
  include_recipe 'apt::unattended-upgrades'
  include_recipe 'postfix'
  include_recipe 'rsyslogd::mute-cron'
  include_recipe 'monit::service'
end
