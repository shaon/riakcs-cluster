node_head = node['riakcs_cluster']['topology']['head']['fqdn']

execute "join-cluster" do
  command "riak-admin cluster join riak@#{node_head}"
end
