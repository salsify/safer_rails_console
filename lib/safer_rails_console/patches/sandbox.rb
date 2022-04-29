# frozen_string_literal: true

Dir[File.join(__dir__, 'sandbox', '*.rb')].sort.each { |file| require file }
