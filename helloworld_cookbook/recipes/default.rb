app = search(:aws_opsworks_app).first
app_path = "/srv/#{app['shortname']}"
Chef::Log.info("app is ... #{app}")
Chef::Log.info("apppath is ... #{app_path}")

# install the git package
package "git" do
  # workaround for:
  # WARNING: The following packages cannot be authenticated!
  # liberror-perl
  # STDERR: E: There are problems and -y was used without --force-yes
  options "--force-yes" if node["platform"] == "ubuntu" && node["platform_version"] == "14.04"
end

# sync the app repo to the app_path
git "#{app_path}" do
    repository app["app_source"]["url"]
    revision app["app_source"]["revision"]
    action :sync
end

# create a virtual environment if it does not exist

bash "Create a virtual environment" do
  user "ec2-user"
  cwd "/home/ec2-user"
  code <<-EOH
      easy_install pip
      pip install --upgrade pip
      pip install virtualenv
      virtualenv /home/ec2-user/#{app['shortname']}
      source #{app['shortname']}/bin/activate
      pip install -r #{app_path}/requirements.txt
  EOH
  not_if do
      File.exists?("/home/ec2-user/#{app['shortname']}/bin/activate")
  end
end 

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
