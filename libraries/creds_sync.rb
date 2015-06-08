module RiakCSLib
  module RiakKeySync

    def self.fix_sudo_tty(node)
      Chef::Log.info "Fixing tty fix"
      file_name = "/etc/sudoers.d/riak"
      if !File.exists?("/etc/sudoers.d/riak")
        File.open(file_name, 'w') do |file|
          file.puts "Defaults:root !requiretty"
        end
      end
    end

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
      head_ip = node['riakcs_cluster']['topology']['head']['ipaddr']
      environment = node.chef_environment
      Chef::Log.info "Getting all attributes from head"
      head = Chef::Search::Query.new.search(:node, "addresses:#{head_ip}").first.first
      Chef::Log.info "lightbulb first: #{head}"
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
