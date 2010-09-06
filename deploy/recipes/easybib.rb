
# already checks out the code for every app
# do you really want this?
#include_recipe "deploy::source"

node[:deploy].each do |application, deploy|
  case application
  when 'easybib'
    next unless node[:scalarium][:instance][:roles].include?('nginxphpapp')
  when 'easybib_api'
    next unless node[:scalarium][:instance][:roles].include?('bibapi')
  when 'easybib_solr_research_importers'
    # not sure on which roles you want to have this app
    next unless node[:scalarium][:instance][:roles].include?('solr')
    
    deploy[:deploy_to]       = "/solr/research_importers"
    deploy[:restart_command] = ""
  when 'easybib_solr_server'
    # not sure on which roles you want to have this app
    next unless node[:scalarium][:instance][:roles].include?('solr')
    
    deploy[:deploy_to]       = "/solr/apache-solr-1.4-compiled"
    deploy[:restart_command] = "/etc/init.d/solr restart"
  end
  
  # we survived until here - so we are good to actually checkout and deploy
  # done for every app
  
  # fix SVN url - have to look into that
  unless deploy[:scm][:revision].match(/(r[0-9]{1,})|([0-9]{1,})/)
    deploy[:scm][:repository] = "#{deploy[:scm][:repository]}/#{deploy[:scm][:revision]}"
    deploy[:scm][:revision]   = nil
  end
  
  # chef bug
  directory "#{deploy[:deploy_to]}/shared/cached-copy" do
    recursive true
    action :delete
  end
  
  # setup deployment & checkout
  deploy deploy[:deploy_to] do
    repository deploy[:scm][:repository]
    user "www-data"

    if deploy[:scm][:revision].any?
      revision deploy[:scm][:revision]
    end

    migrate deploy[:migrate]
    migration_command deploy[:migrate_command]

    symlink_before_migrate deploy[:symlink_before_migrate]
    action deploy[:action]

    if deploy[:restart_command].any?
      restart_command "sleep #{deploy[:sleep_before_restart]} && #{deploy[:restart_command]}"
    end

    scm_provider Chef::Provider::Subversion
    svn_username deploy[:scm][:user]
    svn_password deploy[:scm][:password]
    svn_arguments "--no-auth-cache"
  end
  
end