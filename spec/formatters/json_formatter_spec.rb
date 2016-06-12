require 'spec_helper'

describe JsonFormatter do
  let(:collection_name) { 'collection' }
  let(:json_formatter) { JsonFormatter.new(collection_name) }

  it 'should be kind of ActiveResource::Formats::JsonFormat' do
    expect(json_formatter).to be_a_kind_of(ActiveResource::Formats::JsonFormat)
  end

  it 'should has attr collection_name' do
    expect(json_formatter).to respond_to :collection_name
  end

  describe '#initialize' do
    it 'should initialize collection_name' do
      expect(json_formatter.collection_name).to be collection_name
    end
  end

  describe '#decode' do
    let(:json) { '{ "elem1": 1, "elem2" : 2 }' }
    let(:json_with_root) { '{ "root" : ' + json + ' }' }

    let(:json_with_root) { '{ "root" : ' + json + ' }' }
    let(:hash) { { 'elem1' => 1, 'elem2' => 2 } }

    it 'should decode and remove root from JSON' do
      expect(json_formatter.decode(json_with_root)).to eq hash
    end
  end

  describe '#remove_root' do
    context 'when root keys count less then 6' do
      it 'should remove root' do
        hash = { 'elem1' => 1, 'elem2' => 2 }
        hash_with_root = { 'root' => hash }
        expect(json_formatter.send(:remove_root, hash_with_root)).to eq hash
      end
    end

    context 'when root keys count greater then 6' do
      it 'should not remove root if count of roots > 6' do
        hash = { 'r1' => 1, 'r2' => 2, 'r3' => 3,
                 'r4' => 4, 'r5' => 5, 'r6' => 6 }
        expect(json_formatter.send(:remove_root, hash)).to eq hash
      end
    end
  end
end
