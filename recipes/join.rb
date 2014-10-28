node_head = node["riak_cluster_join"]["head"]["fqdn"]

execute "join-cluster" do
  command "riak-admin cluster join riak@#{node_head}"
end
