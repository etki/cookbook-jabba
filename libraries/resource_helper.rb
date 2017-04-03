require_relative 'jabba_api'
require 'pathname'

module Etki
  module Chef
    module Jabba
      module ResourceHelper
        def on_windows?
          node['platform_family'] == 'windows'
        end

        def real_directory
          Pathname.new(::Dir.home(user)).join('.jabba')
        end

        def api
          Api.new(real_directory, user)
        end

        def method_missing(method, *args, &block)
          api.send(method, *args, &block)
        end
      end
    end
  end
end