stack_order do
  bootstrap 'riakcs-cluster::head'
  bootstrap 'riakcs-cluster::node'
  bootstrap 'riakcs-cluster::nuke'
  bootstrap 'riakcs-cluster::commit'
end

component 'riakcs-cluster' do
  description "Riakcs-cluster application"

  group 'head' do
    recipe 'riak-cs::package'
    recipe 'riak'
    recipe 'sysctl'
    recipe 'riak-cs'
    recipe 'riak-cs::stanchion'
    recipe 'riak-cs-create-admin-user'
    recipe 'riakcs-cluster::credentials'
    recipe 'riakcs-cluster::sync'
  end

  group 'commit' do
    recipe 'riakcs-cluster::plancommit'
  end

  group 'node' do
    recipe 'riakcs-cluster::sync'
    recipe 'riak-cs::package'
    recipe 'riak'
    recipe 'sysctl'
    recipe 'riak-cs'
    recipe 'riakcs-cluster::join'
    recipe 'riakcs-cluster::mergecreds'
  end

  group 'nuke' do
    recipe 'riakcs-cluster::nuke'
  end

end
