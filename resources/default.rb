actions :install, :delete
default_action :install

property :version, String, name_property: true
property :user, required: true

action_class do
  include Etki::Chef::Jabba::ResourceHelper
end

action :install do
  unless installed? and version?(new_resource.version)
    converge_by "Installing Jabba version '#{version}'" do
      ext = on_windows? ? 'ps1' : 'sh'
      target = "#{Chef::Config['file_cache_path']}/jabba-installer.#{ext}"
      remote_file target do
        source "https://github.com/shyiko/jabba/raw/master/install.#{ext}"
        sensitive true
      end
      interpreter = on_windows? ? 'powershell' : 'bash'
      execute "#{interpreter} '#{target}'" do
        user user
        environment({
            JABBA_VERSION: version,
            JABBA_DIR: real_directory.to_s
        })
      end
    end
  end
end

action :delete do
  if installed?
    converge_by "Dropping Jabba directory '#{real_directory}'" do
      directory real_directory.to_s do
        recursive true
        action :delete
      end
    end
  end
end
