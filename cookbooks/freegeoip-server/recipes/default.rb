require 'fileutils'

ruby_block "install freegeoip" do
  block do
    FileUtils.cp(node['freegeoip-pathr'] + '/freegeoip', '/user/bin/')
  end
  not_if { File.exist?('/user/bin/freegeoip') }
end

template node['service_path'] do
  source "service.erb"
end

service node['service_name'] do
  action :start
end

execute "start freegeoip service" do
  cwd "/var/www/freegeoip-server/vendor/freegeoip-3.0.2-linux-amd64"
  command "./freegeoip"
end
