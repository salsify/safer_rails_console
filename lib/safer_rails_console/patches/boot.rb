# frozen_string_literal: true

Dir[File.join(__dir__, 'boot', '*.rb')].sort.each { |file| require file }
