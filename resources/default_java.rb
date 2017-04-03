actions :create, :delete
default_action :create
resource_name :jabba_default

property :name, String, required: true, name_property: true
property :user, String, required: true

action_class do
  include Etki::Chef::Jabba::ResourceHelper
end

[:create, :delete].each do |resource_action|
  action resource_action do
    resource_user = user
    resource_name = name
    jabba_alias 'default' do
      version resource_name
      user(resource_user)
      action resource_action
    end
  end
end
