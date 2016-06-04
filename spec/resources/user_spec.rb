require 'spec_helper'
require 'resources/user'

describe User do
  it 'should inherit BaseResource' do
    expect(User).to be < BaseResource
  end

  describe '#current' do
    it 'gets current user' do
      expect(User).to receive(:find).with(:current)
      User.current
    end
  end
end
