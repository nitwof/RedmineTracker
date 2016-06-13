require 'spec_helper'

describe BaseResource do
  it 'should has JsonForamatter as format' do
    expect(BaseResource.format).to be_a_kind_of(JsonFormatter)
  end

  describe '#serialize' do
    it 'should return json of instance' do
      class BaseResource
        def as_json
          { 'name' => 'name', 'value' => 'value' }
        end
      end
      resource = BaseResource.new
      expect(resource.serialize).to eq name: 'name', value: 'value'
    end
  end
end
