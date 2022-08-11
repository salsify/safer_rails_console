class ActiveJobJob < ApplicationJob
  def perform(*args)
    puts 'Hello World'
  end
end
