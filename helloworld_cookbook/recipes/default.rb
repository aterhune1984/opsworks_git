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

application app_path do
    Chef::Log.info("inside application do statement")
end
