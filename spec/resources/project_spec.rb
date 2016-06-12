require 'spec_helper'

describe Project do
  it 'should inherit BaseResource' do
    expect(Project).to be < BaseResource
  end
end
