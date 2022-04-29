# frozen_string_literal: true

Dir[File.join(__dir__, 'railtie', '*.rb')].sort.each { |file| require file }
