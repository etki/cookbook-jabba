actions :install, :delete
default_action :install

property :version, String, name_property: true
property :url, [String, NilClass], default: nil
property :user, String, required: true

action_class do
  include Etki::Chef::Jabba::ResourceHelper
end

action :create do
  unless java_installed?(version)
    converge_by "Installing Java '#{version}'" do
      install_java(version, url)
    end
  end
end

action :delete do
  if java_installed?(version)
    converge_by "Deleting Java '#{version}'" do
      delete_java(version)
    end
  end
end
