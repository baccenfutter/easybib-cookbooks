include_recipe "easybib::role-phpapp"
include_recipe "snooze"
include_recipe "postfix"

if is_aws
  include_recipe "easybib_deploy::easybib-housekeeping"
end
