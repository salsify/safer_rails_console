# frozen_string_literal: true

Dir[File.join(__dir__, 'railtie', '*.rb')].each { |file| require file }
