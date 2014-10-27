ruby_block "Manage-RiakCS-Credentials" do
  block do
    if node.recipe?("riak-cs-create-admin-user")
      RiakCSLib::RiakKeySync.upload_riak_credentials(node)
    else
      RiakCSLib::RiakKeySync.download_riak_credentials(node)
    end
  end
end
