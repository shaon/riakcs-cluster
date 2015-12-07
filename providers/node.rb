# Some snippets are written with the help of following repository,
# https://github.com/bakins/cookbook-riak-cluster/blob/master/providers/default.rb

def get_ring
  cmd = Mixlib::ShellOut::new("riak-admin ringready")
  cmd.run_command
  {
    :ready => cmd.stdout =~ /TRUE/,
    :members => cmd.stdout.scan(/'([^',]+)'/).flatten,
    :running => cmd.stderr !~ /Node is not running/
  }
end

def joined?
  ring = get_ring
  ring[:members].size > 1
end

def do_plan_commit
  cmd = Mixlib::ShellOut.new("riak-admin cluster plan").run_command
  sleep(10)
  cmd = Mixlib::ShellOut.new("riak-admin cluster commit").run_command
end

action :join do
  ring = get_ring
  Chef::Application.fatal!("Local node must be running to join a cluster.") unless ring[:running]
  if joined?
    Chef::Log.info "Node: '#{node['fqdn']}' is already with a Riak cluster, nothing to do."
  else
    Chef::Log.info "Joining node: '#{node['fqdn']}' to Riak cluster with node: '#{new_resource.head}'"
    cmd = Mixlib::ShellOut.new("riak-admin cluster join riak@#{new_resource.head}").run_command
    sleep(10)
    do_plan_commit
    new_resource.updated_by_last_action(true)
  end
end

action :leave do
  Chef::Log.info "Node '#{node['fqdn']}' is leaving from cluster."
  if joined?
    cmd = Mixlib::ShellOut.new("riak-admin cluster leave").run_command
    sleep(10)
    do_plan_commit
    new_resource.updated_by_last_action(true)
  else
    Chef::Log.info "Node '#{node['fqdn']}' is not in any cluster, nothing to do."
  end
end
