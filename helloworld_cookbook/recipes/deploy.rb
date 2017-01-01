app = search(:aws_opsworks_app).first
Chef::Log.info("********** The app's environment is '#{app['environment']}' **********")


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
    action :restart
end
