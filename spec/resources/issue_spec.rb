require 'spec_helper'
require 'resources/issue'

describe Issue do
  it 'should inherit BaseResource' do
    expect(Issue).to be < BaseResource
  end
end
