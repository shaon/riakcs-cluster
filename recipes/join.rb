node_head = node['riakcs_cluster']['topology']['head']['fqdn']

member_status = ""
member_status = Mixlib::ShellOut.new("riak-admin member-status | grep #{node['hostname']}").run_command.stdout.strip
if member_status == ""
  execute "join-cluster" do
    command "riak-admin cluster join riak@#{node_head}"
  end
end
