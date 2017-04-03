require 'mixlib/shellout'

module Etki
  module Chef
    module Jabba
      class Api
        def initialize(location, user)
          @location = location
          @user = user
        end

        def installed?
          ::File.exists?(binary)
        end

        def installed!
          unless installed?
            raise <<-DOC
              Jabba installation not found at '#{binary}'. 
              Please ensure you install Jabba at this location before trying to perform any other actions. 
              If you're sure you did everything right, please file a bug report.
            DOC
          end
        end

        def version
          read_line '--version'
        end

        def version?(version)
          self.version == version
        end

        def java_installed?(version)
          read_line('which', version) != nil
        end

        def java_installed!(version)
          raise "Java #{version} is not installed" unless java_installed?(version)
        end

        def java_not_installed!(version)
          raise "Java #{version} is already installed" if java_installed?(version)
        end

        def install_java(version, url = nil)
          java_not_installed!(version)
          execute 'install', url ? "#{version}=#{url}" : version
        end

        def delete_java(version)
          java_installed!(version)
          execute 'uninstall', version
        end

        def read_alias(alias_name)
          read_line('alias', alias_name)
        end

        def alias_exists?(alias_name)
          read_alias(alias_name) != nil
        end

        def alias_exists!(alias_name)
          raise "Alias #{alias_name} doesn't exist" unless alias_exists?(alias_name)
        end

        def alias_not_exists!(alias_name)
          raise "Alias #{alias_name} already exists" if alias_exists?(alias_name)
        end

        def create_alias(alias_name, java)
          alias_not_exists!(alias_name)
          execute('alias', alias_name, java)
        end

        def delete_alias(alias_name)
          alias_exists!(alias_name)
          execute('unalias', alias_name)
        end

        def read_link(link_name)
          read_line('link', link_name)
        end

        def link_exists?(link_name)
          read_link(link_name) != nil
        end

        def link_exists!(link_name)
          raise "Link #{link_name} doesn't exist" unless link_exists?(link_name)
        end

        def link_not_exists!(link_name)
          raise "Link #{link_name} already exists" if link_exists?(link_name)
        end

        def create_link(version, target)
          execute('link', version, target)
        end

        def delete_link(version)
          execute('unlink', version)
        end

        def execute(*command)
          installed!
          Mixlib::ShellOut.new('ls', '/').run_command.error!
          execution = Mixlib::ShellOut.new(binary, *command, {user: @user})
          execution.run_command
          execution.error!
          execution
        end

        def binary
          ::File.join(@location, 'bin', 'jabba')
        end

        private
        def read_line(*command)
          execution = execute *command
          output = execution.stdout.strip
          output.length > 0 ? output : nil
        end
      end
    end
  end
end
