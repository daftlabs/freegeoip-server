require 'fileutils'
include_recipe "apt"
include_recipe "git"

unless Chef::Config[:solo] then
  directory "/var/www/.ssh" do
    recursive true
  end

  rsa_key = data_bag_item('deploy_keys', 'freegeoip')['key']

  file "/var/www/.ssh/id_rsa" do
    content rsa_key
    mode 00600
  end

  ssh_wrapper_file = "/var/www/.ssh/.gitssh"

  file ssh_wrapper_file do
    content "exec ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i \"/var/www/.ssh/id_rsa\" \"$@\""
    mode 00755
  end

  git node['repo_directory'] do
    repository "git@github.com:daftlabs/freegeoip-server.git"
    enable_submodules true
    ssh_wrapper ssh_wrapper_file
    if node.attribute?(:git_ref) then
      revision node.git_ref
    end
  end
end

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

package "nginx"

template "/etc/nginx/conf.d/freegeoip.conf" do
  source "conf.erb"
end

file "/etc/nginx/sites-enabled/default" do
  action :delete
end

execute "service nginx restart"

