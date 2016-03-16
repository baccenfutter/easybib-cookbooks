include_recipe 'nginx-app::cache'

easybib_nginx 'api' do
  config_template 'silex.conf.erb'
  htpasswd '/some_path'
  domain_name 'some_domainname'
  deploy_dir '/some_path'
  app_dir '/some_other_path'
end

easybib_nginx 'domainadmin' do
  config_template 'static.conf.erb'
  domain_name 'manage.example.org'
  deploy_dir '/some_path'
  app_dir '/some_other_path'
end
