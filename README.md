# vagrant-riak-cluster

# Requirements

* [Oracle VM VirtualBox](https://www.virtualbox.org)
* [Vagrant](http://www.vagrantup.com)

# Usage

    $ vagrant plugin install vagrant-cachier
    $ vagrant plugin install vagrant-omnibus
    $ git clone git@github.com:holidayworking/vagrant-riak-cluster.git
    $ cd vagrant-riak-cluster
    $ bundle install --path vendor/bundle --binstubs=vendor/bin
    $ bundle exec berks vendor cookbooks
    $ vagrant up
    $ for node in riak{2,3,4,5}; do; vagrant ssh $node -c "sudo riak-admin cluster join riak@192.168.33.11"; done;
    $ vagrant ssh riak1
    [vagrant@riak1 ~]$ sudo riak-admin cluster plan
    [vagrant@riak1 ~]$ sudo riak-admin cluster commit

# Author

Author:: Hidekazu Tanaka (<hidekazu.tanaka@gmail.com>)