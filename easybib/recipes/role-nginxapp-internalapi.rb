Chef::Log.warn('DEPRECATED: This setup is still not using the new stack-* cookbooks!')
include_recipe 'stack-citationapi::role-internalapi'
