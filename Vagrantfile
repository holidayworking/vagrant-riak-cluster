NODES = ENV['NODES'].nil? ? 5 : ENV['NODES'].to_i

Vagrant.configure(2) do |cluster|
  cluster.omnibus.chef_version = '11.18.0'

  cluster.cache.scope = :box if Vagrant.has_plugin?('vagrant-cachier')

  (1..NODES).each do |i|
    cluster.vm.define "riak#{i}".to_sym do |config|
      config.vm.box = 'bento/centos-7.2'

      config.vm.hostname = "riak#{i}"
      config.vm.network :private_network, ip: "192.168.33.1#{i}"

      config.vm.provider :virtualbox do |vb|
        vb.memory = '1024'

        vb.linked_clone = true
      end

      config.vm.provision 'shell', inline: 'nmcli connection reload;systemctl restart network.service'

      config.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = %w(cookbooks site-cookbooks)

        chef.add_recipe 'java'
        chef.add_recipe 'datastore::riak'
        chef.json = {
          "java" => {
            "install_flavor" => "oracle",
            "jdk_version" => "7",
            "oracle" => {
              "accept_oracle_download_terms" => true
            }
          },
          "riak" => {
            "config" => {
              "nodename" => "riak@192.168.33.1#{i}"
            }
          }
        }
      end
    end
  end
end
