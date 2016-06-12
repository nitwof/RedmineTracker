require 'spec_helper'

describe BaseResource do
  it 'should has site' do
    expect(BaseResource.site).not_to be_nil
  end

  it 'should has username' do
    expect(BaseResource.user).not_to be_nil
  end

  it 'should has password' do
    expect(BaseResource.password).not_to be_nil
  end

  it 'should has JsonForamatter as format' do
    expect(BaseResource.format).to be_a_kind_of(JsonFormatter)
  end

  it 'should has API key' do
    expect(BaseResource.headers['X-Redmine-API-Key']).not_to be_nil
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
