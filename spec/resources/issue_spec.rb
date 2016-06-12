require 'spec_helper'

describe Issue do
  it 'should inherit BaseResource' do
    expect(Issue).to be < BaseResource
  end
end
