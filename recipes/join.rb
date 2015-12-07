node_head = node['riakcs_cluster']['topology']['head']['fqdn']

riakcs_cluster_node "join-cluster" do
  head "#{node_head}"
  action :join
  only_if "rpm -qa | grep riak"
end
