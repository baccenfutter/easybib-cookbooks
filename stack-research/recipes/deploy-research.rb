node['deploy'].each do |application, deploy|

  case application
  when 'research_app'
    next unless allow_deploy(application, 'research_app', 'research_app')
  else
    Chef::Log.info("stack-research::deploy-research - #{application} (in stack-citationapi) skipped")
    next
  end

  Chef::Log.info("deploy::#{application} - Deployment started.}")
  Chef::Log.info("deploy::#{application} - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  easybib_deploy application do
    deploy_data deploy
    app application
    notifies node['easybib_deploy']['php-fpm']['restart-action'], 'service[php-fpm]'
  end

  # clean up old config before migration
  file '/etc/nginx/sites-enabled/easybib.com.conf' do
    action :delete
    ignore_failure true
  end

  easybib_nginx application do
    cookbook 'stack-research'
    config_template 'research-app.conf.erb'
    notifies :reload, 'service[nginx]', :delayed
    notifies node['easybib_deploy']['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
  end

end
