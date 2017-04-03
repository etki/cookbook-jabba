actions :create, :delete
default_action :create

property :version, String, name_property: true
property :target, String, required: true
property :user, String, required: true

action_class do
  include Etki::Chef::Jabba::ResourceHelper
end

action :create do
  unless link_exists?(target)
    converge_by "Linking installed Java '#{target}' to '#{version}'" do
      create_link(version, target)
    end
  end
end

action :delete do
  if link_exists?(target)
    converge_by "Linking installed Java '#{target}' to '#{version}'" do
      delete_link(version, target)
    end
  end
end
