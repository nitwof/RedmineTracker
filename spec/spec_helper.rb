require 'simplecov'
require 'timecop'

ENV['RT_ENV'] = 'test'

require './config/environment'

SimpleCov.start do
  add_filter 'spec/'
end

RSpec.configure do |config|
  config.order = 'random'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
