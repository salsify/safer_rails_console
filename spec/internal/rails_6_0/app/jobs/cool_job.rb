class CoolJob < ApplicationJob
  def perform(*args)
    puts 'Hello World'
  end
end
