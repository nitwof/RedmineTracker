require 'spec_helper'
require 'resources/time_entry'

describe TimeEntry do
  it 'should inherit BaseResource' do
    expect(TimeEntry).to be < BaseResource
  end
end
