require 'spec_helper'

describe BaseResource do
  it 'should has JsonForamatter as format' do
    expect(BaseResource.format).to be_a_kind_of(JsonFormatter)
  end

  describe '.safe_find' do
    context 'connection established' do
      it 'should call and return .find' do
        expect(ActiveResource::Base).to receive(:find).with(3)
          .and_return('test')
        expect(BaseResource.safe_find(3)).to eq 'test'
      end
    end

    context 'connection broken' do
      it 'should return nil' do
        expect(ActiveResource::Base).to receive(:find).with(3)
          .and_raise(SocketError)
        expect(BaseResource.safe_find(3)).to be_nil
      end
    end
  end

  describe '.safe_all' do
    context 'connection established' do
      it 'should call and return .all' do
        expect(ActiveResource::Base).to receive(:all).with(3)
          .and_return('test')
        expect(BaseResource.safe_all(3)).to eq 'test'
      end
    end

    context 'connection broken' do
      it 'should return empty array' do
        expect(ActiveResource::Base).to receive(:all).with(3)
          .and_raise(SocketError)
        expect(BaseResource.safe_all(3)).to eq []
      end
    end
  end

  describe '.safe_where' do
    context 'connection established' do
      it 'should call and return .where' do
        expect(ActiveResource::Base).to receive(:where).with(3)
          .and_return('test')
        expect(BaseResource.safe_where(3)).to eq 'test'
      end
    end

    context 'connection broken' do
      it 'should return empty array' do
        expect(ActiveResource::Base).to receive(:where).with(3)
          .and_raise(SocketError)
        expect(BaseResource.safe_where(3)).to eq []
      end
    end
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
