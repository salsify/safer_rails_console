# frozen_string_literal: true

module SaferRailsConsole
  module Patches
    module Sandbox
      module ActiveJob
        # ActiveJob
        ActiveJob::Base.queue_adapter = :test if defined?(::ActiveJob)

        # Sidekiq
        require 'sidekiq/testing' if defined?(::Sidekiq)
      end
    end
  end
end
