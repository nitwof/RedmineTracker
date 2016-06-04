require 'simplecov'

SimpleCov.start do
  add_filter 'spec/'
end

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

RSpec.configure do |config|
  config.order = 'random'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
#
# class String
#   def underscore
#     self.gsub(/::/, '/').
#       gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
#       gsub(/([a-z\d])([A-Z])/,'\1_\2').
#       tr('-', '_').
#       downcase
#   end
# end
