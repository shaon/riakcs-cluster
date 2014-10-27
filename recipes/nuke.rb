service "riak-cs" do
  action :stop
  ignore_failure true
  only_if do ::File.exists?('/etc/init.d/riak-cs') end
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
  only_if "ps aux | grep beam"
end

execute "kill epmd" do
  command "killall epmd"
  ignore_failure true
  only_if "ps aux | grep epmd"
end

yum_package "riak" do
  action :remove
  ignore_failure true
end

yum_package "riak-cs" do
  action :remove
end

yum_package "stanchion" do
  action :remove
end

execute "remove all stanchion artifacts" do
  command "for x in `find / -name 'stanchion'`; do rm -rf $x*; done"
end

execute "remove all riak/cs artifacts" do
  command "for x in `find / -name 'riak*'`; do rm -rf $x*; done"
end

execute "yum-clean" do
  command "yum clean all"
end
