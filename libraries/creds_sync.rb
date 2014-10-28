module RiakCSLib
  module RiakKeySync

    def self.upload_riak_credentials(node)
      Chef::Log.info "Saving credentials.."
      if File.exists?("/root/creds.txt")
        cert = Base64.encode64(::File.new("/root/creds.txt").read)
        node.set['riak_cs']['credentials'] = cert
        node.save
      end
    end

    def self.download_riak_credentials(node)
      head = nil
      retry_count = 1
      retry_delay = 10
      total_retries = 12

      begin
        head_ip = node["riak_cluster_join"]["head"]["ipaddress"]
        environment = node.chef_environment
        Chef::Log.info "Getting all attributes from head"
        head = Chef::Search::Query.new.search(:node, "addresses:#{head_ip}").first.first
        Chef::Log.info "lightbulb first: #{head}"
        if head.nil?
          raise "Failed to get head attributes"
        end
      rescue Exception => e
        if retry_count < total_retries
          sleep retry_delay
          retry_count += 1
          Chef::Log.info "Retrying search for head:#{head_ip}"
          retry
        else
          raise e
        end
      end

      cert = head.attributes['riak_cs']['credentials']
      node.set['riak_cs']['credentials'] = cert
      node.save

      file_name = "/root/creds.txt"
      File.open(file_name, 'w') do |file|
        file.puts Base64.decode64(node['riak_cs']['credentials'])
      end
      FileUtils.chmod 0644, file_name
    end

  end
end
