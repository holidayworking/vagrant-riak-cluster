node.default['sysctl']['params']['vm']['swappiness'] = node['riak']['sysctl']['vm']['swappiness']
node.default['sysctl']['params']['net']['core']['somaxconn'] = node['riak']['sysctl']['net']['core']['somaxconn']
node.default['sysctl']['params']['net']['ipv4']['tcp_max_syn_backlog'] = node['riak']['sysctl']['net']['ipv4']['tcp_max_syn_backlog']
node.default['sysctl']['params']['net']['ipv4']['tcp_sack'] = node['riak']['sysctl']['net']['ipv4']['tcp_sack']
node.default['sysctl']['params']['net']['ipv4']['tcp_window_scaling'] = node['riak']['sysctl']['net']['ipv4']['tcp_window_scaling']
node.default['sysctl']['params']['net']['ipv4']['tcp_fin_timeout'] = node['riak']['sysctl']['net']['ipv4']['tcp_fin_timeout']
node.default['sysctl']['params']['net']['ipv4']['tcp_keepalive_intvl'] = node['riak']['sysctl']['net']['ipv4']['tcp_keepalive_intvl']
node.default['sysctl']['params']['net']['ipv4']['tcp_tw_reuse'] = node['riak']['sysctl']['net']['ipv4']['tcp_tw_reuse']
node.default['sysctl']['params']['net']['ipv4']['tcp_moderate_rcvbuf'] = node['riak']['sysctl']['net']['ipv4']['tcp_moderate_rcvbuf']

include_recipe 'ulimit'
include_recipe 'sysctl'

user_ulimit 'riak' do
  filehandle_limit node['riak']['limits']['nofile']
end

include_recipe 'riak::package'

file "#{node['riak']['platform_etc_dir']}/riak.conf" do
  content Cuttlefish.compile('', node['riak']['config']).join("\n")
  owner 'root'
  mode 0644
  notifies :restart, 'service[riak]'
end

node['riak']['patches'].each do |patch|
  cookbook_file "#{node['riak']['platform_data_dir']}/lib/basho-patches/#{patch}" do
    source patch
    owner 'root'
    mode 0644
    notifies :restart, 'service[riak]'
  end
end

directory node['riak']['platform_data_dir'] do
  owner 'riak'
  group 'riak'
  mode 0755
  action :create
end

service 'riak' do
  supports start: true, stop: true, restart: true, status: true
  action [:enable, :start]
end
