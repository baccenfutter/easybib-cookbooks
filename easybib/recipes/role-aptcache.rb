include_recipe 'ies::role-generic'

if get_instance_roles.include?('aptcache')
  include_recipe 'apt::cacher-ng'
end
