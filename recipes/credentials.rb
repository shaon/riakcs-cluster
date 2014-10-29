ruby_block "credentials-file" do
  block do
    if node.run_state.key?("riak_cs_admin_key") && node.run_state.key?("riak_cs_admin_secret")
      creds_file = Chef::Resource::File.new("/root/creds.txt", run_context)
      creds_file.content "RIAKCS_ACCESS_KEY_ID:%s\nRIAKCS_SECRET_ACCESS_KEY:%s\n" %
        [ node.run_state["riak_cs_admin_key"], node.run_state["riak_cs_admin_secret"] ]
      creds_file.run_action :create
    end
  end
end
