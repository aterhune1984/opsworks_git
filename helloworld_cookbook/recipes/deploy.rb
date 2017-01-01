app = search(:aws_opsworks_app).first
environment=#{app['environment']['ENVIRONMENT']}
Chef::Log.info("USER_ID: #{node[:deploy]['simplephpapp'][:environment_variables][:USER_ID]}")

cookbook_file "Copy a file" do
    group "root"
    mode "0755"
    owner "root"
    path "/etc/init.d/helloworld"
    source "helloworld.sh"
end

execute "add to chkconfig" do
  command "chkconfig --add helloworld"
end

service 'helloworld' do
    action :start
end
