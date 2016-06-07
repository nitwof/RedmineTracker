shared_examples 'model' do |model|
  before(:all) { model.store.create(model.table) }
  after(:all) { model.store.destroy(model.table) }

  it 'has store' do
    expect(model).to respond_to :store
    expect(model.store).not_to be_nil
  end

  it 'responds to table' do
    expect(model).to respond_to :table
  end

  context 'table is not exists' do
    it 'creates table' do
      expect(model.store.exists?(model.table)).to be_truthy
    end
  end

  describe '.all' do
    before(:all) { model.destroy_all }

    it 'returns all models' do
      fill_table(model, 3)
      all = model.all
      expect(all).not_to be_nil
      expect(all.size).to eq 3
      expect(all.first).to be_a model
    end

    it 'uses store' do
      expect(Store::YAML.instance).to receive(:select).with(model.table)
      model.all
    end
  end

  describe '.find' do
    before(:each) { model.destroy_all }

    context 'object exists' do
      it 'returns object' do
        object = model.create
        result = model.find(object.id)
        expect(result).not_to be_nil
        expect(result.id).to eq object.id
      end
    end

    context 'object not exists' do
      it 'returns nil' do
        expect(model.find('1234567890')).to be_nil
      end
    end

    it 'uses store' do
      expect(Store::YAML.instance).to receive(:find).with(model.table,
                                                          '1234567890')
      model.find('1234567890')
    end
  end

  describe '.select' do
    before(:each) { model.destroy_all }

    context 'matches found' do
      it 'returns array with matched objects' do
        fill_table(model, 5)
        result = model.select
        expect(result).to be_a Array
        expect(result.size).to eq 5
      end
    end

    context 'no matches found' do
      it 'returns empty array' do
        result = model.select
        expect(result).to be_a Array
        expect(result).to eq []
      end
    end

    it 'uses store' do
      expect(Store::YAML.instance).to receive(:select).with(model.table,
                                                            id: '1234567890')
      model.select(id: '1234567890')
    end
  end

  describe '.create' do
    before(:each) { model.destroy_all }

    it 'creates and return object' do
      object = model.create
      expect(object).to be_a model
      expect(object.id).not_to be_nil
      expect(model.find(object.id).id).to eq object.id
    end

    it 'creates instance' do
      expect(model).to receive(:new).with(id: nil).and_call_original
      model.create
    end
  end

  describe '.destroy_all' do
    it 'destroys all objects' do
      fill_table(model, 5)
      model.destroy_all
      expect(model.all).to eq []
    end

    it 'uses store' do
      expect(Store::YAML.instance).to receive(:truncate).with(model.table)
      model.destroy_all
    end
  end

  describe '#initialize' do
    context 'params given' do
      it 'initializes object with params' do
        object = model.new(id: '1234567890')
        expect(object).not_to be_nil
        expect(object.id).to eq '1234567890'
      end
    end

    context 'no params given' do
      it 'initializes object with nil params' do
        object = model.new
        expect(object).not_to be_nil
        expect(object.id).to be_nil
      end
    end
  end

  describe '#[]' do
    it 'returns instance variable' do
      object = model.new(id: '1234567890')
      expect(object[:id]).to eq '1234567890'
    end
  end

  describe '#[]=' do
    it 'sets instance variable' do
      object = model.new
      object[:id] = '1234567890'
      expect(object[:id]).to eq '1234567890'
    end
  end

  describe '#save' do
    context 'object with id does not exist' do
      it 'creates and returns object' do
        object = model.new
        object.save
        expect(object).to be_a model
        expect(object.id).not_to be_nil
        expect(model.find(object.id).as_json).to eq object.as_json
      end

      it 'uses store insert' do
        object = model.new
        expect(Store::YAML.instance).to receive(:insert).with(model.table,
                                                              object)
        object.save
      end

      it 'updates created_at and updated_at' do
        time_before = Time.current
        object = model.new.save
        time_after = Time.current
        expect(object.created_at).to be_between(time_before, time_after)
        expect(object.updated_at).to be_between(time_before, time_after)
      end
    end

    context 'object with id exists' do
      let(:object) { model.create }

      it 'updates and returns object' do
        object[:key] = 'value'
        object.save
        expect(object[:key]).to eq 'value'
        expect(model.find(object.id).as_json).to eql object.as_json
      end

      it 'uses store update' do
        object[:key] = 'value'
        expect(Store::YAML.instance).to receive(:update).with(model.table,
                                                              object.id, object)
        object.save
      end

      it 'updates updated_at' do
        time_before = Time.current
        object.save
        time_after = Time.current
        expect(object.updated_at).to be_between(time_before, time_after)
      end
    end
  end

  describe '#destroy' do
    before(:each) { model.destroy_all }

    context 'object exists' do
      let(:object) { model.create }

      it 'destroys and returns object' do
        result = object.destroy
        expect(result).not_to be_nil
        expect(result.as_json).to eq object.as_json
        expect(model.all).to eq []
        expect(model.find(object.id)).to be_nil
      end
    end

    context 'object does not exist' do
      let(:object) { model.new }

      it 'does not destroy object and returns nil' do
        result = object.destroy
        expect(result).to be_nil
        expect(model.all).to eq []
        expect(model.find(object.id)).to be_nil
      end
    end

    it 'uses store delete' do
      object = model.create
      expect(Store::YAML.instance).to receive(:delete).with(model.table,
                                                            object.id)
      object.destroy
    end
  end

  def fill_table(model, count)
    (1..count).each do
      model.create
    end
  end
end
