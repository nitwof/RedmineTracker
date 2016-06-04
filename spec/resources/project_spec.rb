require 'spec_helper'
require 'resources/project'

describe Project do
  it 'should inherit BaseResource' do
    expect(Project).to be < BaseResource
  end
end
