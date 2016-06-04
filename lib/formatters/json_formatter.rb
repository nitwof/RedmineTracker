require 'active_resource'

class JsonFormatter
  include ActiveResource::Formats::JsonFormat

  attr_reader :collection_name

  def initialize(collection_name)
    @collection_name = collection_name.to_s
  end

  def decode(json)
    remove_root(ActiveSupport::JSON.decode(json))
  end

  private

  def remove_root(data)
    if data.is_a?(Hash) && data.keys.size <= 5
      data.values.first
    else
      data
    end
  end
end
