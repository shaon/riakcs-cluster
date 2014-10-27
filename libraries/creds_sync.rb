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
      head = Chef::Search::Query.new.search(:node, "addresses:#{node["riak_cluster_join"]["head"]["ipaddress"]}").first

      cert = head.first.attributes['riak_cs']['credentials']
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
