require 'spec_helper'

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

  describe '#name' do
    it 'returns full name' do
      User.site = ''
      user = User.new(firstname: 'Firstname', lastname: 'Lastname')
      expect(user.name).to eq 'Firstname Lastname'
    end
  end
end
