execute "plan-changes" do
  command "riak-admin cluster plan"
end

sleep 20

execute "commit-changes" do
  command "riak-admin cluster commit"
end
