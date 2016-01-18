include_recipe 'ulimit'

user_ulimit 'riak' do
  filehandle_limit node['riak']['limits']['nofile']
end

include_recipe 'riak::package'

file "#{node['riak']['platform_etc_dir']}/riak.conf" do
  content lazy { Cuttlefish.compile('', node['riak']['config']).join("\n") }
  owner 'root'
  mode 0644
  notifies :restart, 'service[riak]'
end

node['riak']['patches'].each do |patch|
  cookbook_file "#{node['riak']['platform_lib_dir']}/basho-patches/#{patch}" do
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
