require 'spec_helper'
require 'stores/yaml'

describe Store::YAML do
  let(:store) { Store::YAML.instance }

  after(:all) { Store::YAML.instance.destroy(:test) }

  it 'is Singleton' do
    expect(Store::YAML).to be < Singleton
  end

  describe '#initialize' do
    it 'init YAML::Store as store' do
      expect(store.store).to be_kind_of(YAML::Store)
    end
  end

  describe '#create' do
    it 'creates table' do
      store.destroy :test
      store.create :test
      expect(store.select(:test)).to eq []
    end
  end

  describe '#truncate' do
    before(:each) { store.create(:test) }

    it 'truncates table' do
      fill_store(store, :test, 3)
      store.truncate :test
      expect(store.select(:test)).to eq []
    end
  end

  describe '#destroy' do
    it 'destroys table' do
      store.create :test
      store.destroy :test
      expect(store.select(:test)).to be_nil
    end
  end

  describe '#exists?' do
    context 'table is exists' do
      before(:each) { store.create(:test) }

      it 'returns true' do
        expect(store.exists?(:test)).to be_truthy
      end
    end

    context 'table is not exists' do
      before(:each) { store.destroy(:test) }

      it 'returns false' do
        expect(store.exists?(:test)).to be_falsey
      end
    end
  end

  describe '#empty?' do
    before(:each) { store.create(:test) }

    context 'table is empty' do
      it 'returns true' do
        expect(store.empty?(:test)).to be_truthy
      end
    end

    context 'table is not empty' do
      before(:each) { fill_store(store, :test, 3) }

      it 'returns false' do
        expect(store.empty?(:test)).to be_falsey
      end
    end
  end

  describe '#insert' do
    before(:each) { store.create(:test) }

    it 'inserts row and return row with id' do
      object = { id: nil, test: 'test' }
      row = store.insert(:test, object)
      expect(row).to eq object.merge(id: row[:id])
      expect(row[:id]).not_to be_nil
      expect(store.find(:test, row[:id])).to eq object
    end
  end

  describe '#find' do
    before(:each) { store.create(:test) }

    context 'row exists' do
      let(:row) { store.insert(:test, id: nil, test: 'test') }

      it 'returns row' do
        expect(store.find(:test, row[:id])).to eq row
      end
    end

    context 'row is not exists' do
      it 'returns nil' do
        expect(store.find(:test, 1)).to be_nil
      end
    end
  end

  describe '#select' do
    before(:each) do
      store.create(:test)
      fill_store(store, :test, 5)
    end

    it 'selects all rows' do
      expect(store.select(:test).size).to eq 5
    end

    it 'selects by param' do
      rows = store.select(:test, test: 'test3')
      expect(rows.size).to eq 1
      expect(rows).to eq [{ id: rows.first[:id], test: 'test3' }]
    end
  end

  describe '#update' do
    before(:each) { store.create(:test) }

    it 'updates row by id' do
      row = store.insert(:test, id: nil, test: '')
      object = { id: row[:id], test: 'Test' }
      store.update(:test, row[:id], object)
      expect(store.find(:test, row[:id])).to eq object
    end
  end

  describe '#delete' do
    before(:each) { store.create(:test) }

    it 'deletes row' do
      row = store.insert(:test, id: nil, test: 'test')
      store.delete(:test, row[:id])
      expect(store.select(:test).size).to eq 0
    end
  end

  describe '#find_index' do
    before(:each) { store.create(:test) }

    context 'row exists' do
      let(:object) { { id: nil, test: 'test' } }
      let(:row) { store.insert(:test, object) }

      it 'returns row' do
        index = store.send(:find_index, :test, row[:id])
        expect(store.select(:test)[index]).to eq row
      end
    end

    context 'row is not exists' do
      it 'returns nil' do
        expect(store.send(:find_index, :test, 1)).to be_nil
      end
    end
  end

  def fill_store(store, table, count)
    (1..count).each do |i|
      store.insert(table, id: nil, test: "test#{i}")
    end
  end
end
