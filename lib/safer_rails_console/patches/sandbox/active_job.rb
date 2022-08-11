# frozen_string_literal: true

module SaferRailsConsole
  module Patches
    module Sandbox
      module ActiveJob
        # ActiveJob
        if defined?(::ActiveJob::Base)
          Rails.application.config.active_job.queue_adapter = :test
          ActiveJob::Base.queue_adapter = :test
        end

        # Sidekiq
        require 'sidekiq/testing' if defined?(::Sidekiq)
      end
    end
  end
end
