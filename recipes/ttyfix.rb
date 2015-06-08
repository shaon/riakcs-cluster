## this is to ensure that chef doesn't hit the following error
## STDERR: sudo: sorry, you must have a tty to run sudo
ruby_block "sudo-tty-fix-riak" do
  block do
    RiakCSLib::RiakKeySync.fix_sudo_tty(node)
  end
  not_if { ::File.exists?("/etc/sudoers.d/riak") }
end
