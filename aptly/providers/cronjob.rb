action :create do
  path = new_resource.path

  mirror_name = node['aptly']['mirror_name']
  s3_mirror = "#{node['aptly']['s3_mirror']}:#{node['aptly']['s3_mirror_prefix']}"
  pw = node['aptly']['sign_pass']
  cron_command = "SIGNING_PASS=#{pw} MIRROR_NAME=#{mirror_name} S3_APT_MIRROR=s3:#{s3_mirror} #{path}/mirror-it.rb"

  cron_d 'aptly_sync_launchpad' do
    action :create
    minute '0'
    hour '5'
    user 'root'
    command cron_command
    path node['easybib_deploy']['cron_path']
  end
  new_resource.updated_by_last_action(true)

end