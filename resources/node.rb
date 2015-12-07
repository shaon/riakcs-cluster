actions :join, :leave
attribute :head, kind_of: String, default: "#{node['riakcs_cluster']['topology']['head']['fqdn']}"
