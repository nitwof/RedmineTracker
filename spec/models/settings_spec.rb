require 'spec_helper'
require 'support/factory_girl'
require 'support/model'

describe Settings do
  include_examples 'model', Settings

  it 'inherits BaseModel' do
    expect(Settings).to be < BaseModel
  end

  describe '.method_missing' do
    let(:key) { 'test_method_missing' }

    context 'write method' do
      context 'settings key exists' do
        before { Settings.create(key: key, value: 'test') }

        it 'updates settings' do
          Settings.send("#{key}=".to_sym, 'test1')
          expect(Settings.send(key.to_sym)).to eq 'test1'
        end

        it 'returns value' do
          param = Settings.send("#{key}=".to_sym, 'test1')
          expect(param).to be_instance_of Settings
        end
      end

      context 'settings key does not exists' do
        before(:each) { Settings.destroy_all }

        it 'creates settings' do
          Settings.send("#{key}=".to_sym, 'test1')
          expect(Settings.send(key.to_sym)).to eq 'test1'
        end

        it 'returns param' do
          param = Settings.send("#{key}=".to_sym, 'test1')
          expect(param).to be_instance_of Settings
        end
      end
    end

    context 'read method' do
      context 'settings key exists' do
        let!(:param) { Settings.send("#{key}=".to_sym, 'test') }

        it 'returns value' do
          expect(Settings.send(key.to_sym)).to eq param.value
        end
      end

      context 'settings key does not exists' do
        before(:each) { Settings.destroy_all }

        it 'returns nil' do
          expect(Settings.send(key.to_sym)).to be_nil
        end
      end
    end
  end

  describe '.set_value' do
    let(:key) { 'test_set_value' }

    context 'settings key exists' do
      before { Settings.create(key: key, value: 'test') }

      it 'updates settings' do
        Settings.set_value(key, 'test1')
        param = Settings.find_by_key(key)
        expect(param).not_to be_nil
        expect(param.value).to eq 'test1'
      end

      it 'returns param' do
        expect(Settings.set_value(key, 'test1')).to be_instance_of Settings
      end
    end

    context 'settings key does not exists' do
      before(:each) { Settings.destroy_all }

      it 'creates settings' do
        Settings.set_value(key, 'test1')
        param = Settings.find_by_key(key)
        expect(param).not_to be_nil
        expect(param.value).to eq 'test1'
      end

      it 'returns param' do
        expect(Settings.set_value(key, 'test1')).to be_instance_of Settings
      end
    end
  end

  describe '.find_by_key' do
    let(:key) { 'test_find_by_key' }

    context 'settings key exists' do
      let!(:param) { Settings.create(key: key, value: 'test') }

      it 'returns param' do
        expect(Settings.find_by_key(key).to_json).to eq param.to_json
      end
    end

    context 'settings key does not exists' do
      before(:each) { Settings.destroy_all }

      it 'returns nil' do
        expect(Settings.find_by_key(key)).to be_nil
      end
    end
  end
end
