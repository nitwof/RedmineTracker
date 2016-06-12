require 'spec_helper'

describe TimeEntry do
  it 'should inherit BaseResource' do
    expect(TimeEntry).to be < BaseResource
  end
end
