# frozen_string_literal: true

module SaferRailsConsole
  module Patches
    module Sandbox
      module ActiveJob
        if defined?(::Sidekiq)
          require 'sidekiq/testing'
        end
      end
    end
  end
end
