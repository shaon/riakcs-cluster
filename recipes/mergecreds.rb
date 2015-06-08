ruby_block "trigger-delayed-restarts" do
  block { }
  notifies :restart, "service[riak-cs]", :immediately

  if node.recipe?("riak-cs::stanchion")
    notifies :restart, "service[stanchion]", :immediately
  end

  if node.recipe?("riak-cs::control")
    notifies :restart, "service[riak-cs-control]", :immediately
  end
end

ruby_block "merge-creds" do
  block do

    admin_key = "admin-key"
    admin_secret = "admin-secret"

    if File.exists?("/root/creds.txt")
      hash = Hash[File.read('/root/creds.txt').split("\n").map{|i|i.split(':')}]
      admin_key = hash['RIAKCS_ACCESS_KEY_ID']
      admin_secret = hash['RIAKCS_SECRET_ACCESS_KEY']
    end

    riak_cs_config = node["riak_cs"]["config"].to_hash
    riak_cs_config = riak_cs_config.merge(
      "riak_cs" => riak_cs_config["riak_cs"].merge(
        "admin_key" => admin_key.to_erl_string,
        "admin_secret" => admin_secret.to_erl_string,
        "stanchion_ip" => node['riakcs_cluster']['topology']['stanchion_ip'].to_erl_string,
        "stanchion_port" => node['riakcs_cluster']['topology']['stanchion_port']
      )
    )
    riak_cs_file = resources(:file => "#{node['riak_cs']['package']['config_dir']}/app.config")
    riak_cs_file.content Eth::Config.new(riak_cs_config).pp

    if node.recipe?("riak-cs::stanchion")
      stanchion_config = node["stanchion"]["config"].to_hash
      stanchion_config = stanchion_config.merge(
        "stanchion" => stanchion_config["stanchion"].merge(
          "admin_key" => admin_key.to_erl_string,
          "admin_secret" => admin_secret.to_erl_string
        )
      )
      stanchion_file = resources(:file => "#{node['stanchion']['package']['config_dir']}/app.config")
      stanchion_file.content Eth::Config.new(stanchion_config).pp
    end

    if node.recipe?("riak-cs::control")
      riak_cs_control_config = node["riak_cs_control"]["config"].to_hash
      riak_cs_control_config = riak_cs_control_config.merge(
        "riak_cs_control" => riak_cs_control_config["riak_cs_control"].merge(
          "cs_admin_key" => admin_key.to_erl_string,
          "cs_admin_secret" => admin_secret.to_erl_string
        )
      )
      riak_cs_control_file = resources(:file => "#{node['riak_cs_control']['package']['config_dir']}/app.config")
      riak_cs_control_file.content Eth::Config.new(riak_cs_control_config).pp
    end

    node.set["riak_cs"]["config"]["riak_cs"]["anonymous_user_creation"] = false
  end

  retries 5
  retry_delay 3
  notifies :create, "file[#{node['riak_cs']['package']['config_dir']}/app.config]", :immediately

  if node.recipe?("riak-cs::stanchion")
    notifies :create, "file[#{node['stanchion']['package']['config_dir']}/app.config]", :immediately
  end

  if node.recipe?("riak-cs::control")
    notifies :create, "file[#{node['riak_cs_control']['package']['config_dir']}/app.config]", :immediately
  end
end
