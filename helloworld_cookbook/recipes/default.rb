app = search(:aws_opsworks_app).first
app_path = "/srv/#{app['shortname']}"
Chef::Log.info("app is ... #{app}")
Chef::Log.info("apppath is ... #{app_path}")

package "git" do
  # workaround for:
  # WARNING: The following packages cannot be authenticated!
  # liberror-perl
  # STDERR: E: There are problems and -y was used without --force-yes
  options "--force-yes" if node["platform"] == "ubuntu" && node["platform_version"] == "14.04"
end

git "#{app_path}" do
    repository app["app_source"]["url"]
    revision app["app_source"]["revision"]
    action :sync
end

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
      touch /home/ec2-user/testfile
  EOH
  not_if do
      File.exists?("/home/ec2-user/#{app['shortname']}/bin/activate")
  end
end 
