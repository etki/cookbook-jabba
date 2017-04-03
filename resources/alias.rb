actions :create, :delete
default_action :create

property :version, String, required: true
property :user, String, required: true

action_class do
  include Etki::Chef::Jabba::ResourceHelper
end

action :create do
  unless alias_exists?(name)
    converge_by "Creating alias '#{name}' for java '#{version}'" do
      create_alias(name, version)
    end
  end
end

action :delete do
  if alias_exists?(name)
    converge_by "Deleting alias '#{name}'" do
      delete_alias(name)
    end
  end
end
