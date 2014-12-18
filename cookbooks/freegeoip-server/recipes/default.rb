require 'fileutils'

ruby_block "install freegeoip" do
  block do
    FileUtils.cp(node['freegeoip_path'] + '/freegeoip', '/usr/bin/freegeoip')
  end
  not_if { File.exist?('/usr/bin/freegeoip') }
end

template node['service_path'] do
  source "service.erb"
  mode "0755"
end

service 'freegeoip' do
  action :start
end

