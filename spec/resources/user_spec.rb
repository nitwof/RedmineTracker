require 'spec_helper'
require 'resources/user'

describe User do
  it 'should inherit BaseResource' do
    expect(User).to be < BaseResource
  end
end
