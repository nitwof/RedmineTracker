require 'simplecov'
require 'require_all'

SimpleCov.start do
  add_filter 'spec/'
end

require_all 'lib'

RSpec.configure do |config|
  config.order = 'random'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
