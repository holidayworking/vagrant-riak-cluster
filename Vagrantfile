NODES = ENV['NODES'].nil? ? 5 : ENV['NODES'].to_i

Vagrant.configure(2) do |cluster|
  cluster.omnibus.chef_version = '11.18.0'

  cluster.cache.scope = :box if Vagrant.has_plugin?('vagrant-cachier')

  (1..NODES).each do |i|
    cluster.vm.define "riak#{i}".to_sym do |config|
      config.vm.box = 'chef/centos-7.0'

      config.vm.hostname = "riak#{i}"
      config.vm.network :private_network, ip: "192.168.33.1#{i}"

      config.vm.provider :virtualbox do |vb|
        vb.memory = '1024'
      end

      config.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = %w(cookbooks site-cookbooks)

        chef.add_recipe 'datastore::riak'
        chef.json = {
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
