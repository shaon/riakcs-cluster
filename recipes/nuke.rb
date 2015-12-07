service "riak-cs" do
  action :stop
  ignore_failure true
  only_if do ::File.exists?('/etc/init.d/riak-cs') end
end

service "riak-cs-control" do
  action :stop
  ignore_failure true
  only_if do ::File.exists?('/etc/init.d/riak-cs-control') end
end

service "stanchion" do
  action :stop
  ignore_failure true
  only_if do ::File.exists?('/etc/init.d/stanchion') end
end

service "riak" do
  action :stop
  ignore_failure true
  only_if do ::File.exists?('/etc/init.d/riak') end
end

execute "kill beam.smp" do
  command "killall beam.smp"
  ignore_failure true
end

execute "kill epmd" do
  command "killall epmd"
  ignore_failure true
end

yum_package "riak" do
  action :remove
  ignore_failure true
end

yum_package "riak-cs" do
  action :remove
  ignore_failure true
end

yum_package "riak-cs-control" do
  action :remove
  ignore_failure true
end

yum_package "stanchion" do
  action :remove
  ignore_failure true
end

directory '/etc/riak' do
  recursive true
  action :delete
end

directory '/etc/riak-cs' do
  recursive true
  action :delete
end

directory '/etc/riak-cs-control' do
  recursive true
  action :delete
end

directory '/etc/stanchion' do
  recursive true
  action :delete
end

directory '/var/lib/riak' do
  recursive true
  action :delete
end

directory '/var/lib/riak-cs' do
  recursive true
  action :delete
end

directory '/var/lib/riak-cs-control' do
  recursive true
  action :delete
end

directory '/var/lib/stanchion' do
  recursive true
  action :delete
end

directory '/var/log/riak' do
  recursive true
  action :delete
end

directory '/var/log/riak-cs' do
  recursive true
  action :delete
end

directory '/var/log/riak-cs-control' do
  recursive true
  action :delete
end

directory '/var/log/stanchion' do
  recursive true
  action :delete
end

file '/var/lock/subsys/riak' do
  action :delete
end

file '/var/lock/subsys/riak-cs' do
  action :delete
end

file '/var/lock/subsys/riak-cs-control' do
  action :delete
end

file '/var/lock/subsys/stanchion' do
  action :delete
end

file '/etc/security/limits.d/riak_limits.conf' do
  action :delete
end

file '/etc/security/limits.d/riakcs_limits.conf' do
  action :delete
end

file '/etc/security/limits.d/stanchion_limits.conf' do
  action :delete
end

execute "remove all basho repositories" do
  command "rm -rf /etc/yum.repos.d/basho*"
  ignore_failure true
end

execute "remove saved credentials" do
  command "rm -rf /root/creds.txt"
  ignore_failure true
end

execute "yum-clean" do
  command "yum clean all"
end
