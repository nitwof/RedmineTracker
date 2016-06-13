class Settings < BaseModel
  @store = Store::YAML.instance
  @table = :settings

  attr_accessor :key, :value

  def self.method_missing(m, *args, &_block)
    if m.to_s[-1] == '='
      set_value(m[0..-2], args[0])
    else
      find_by_key(m.to_s).try(:value)
    end
  end

  def self.set_value(key, value)
    s = find_by_key(key) || Settings.new(key: key)
    s.value = value
    s.save
  end

  def self.find_by_key(key)
    all.each do |s|
      return s if s.key == key
    end
    nil
  end

  def initialize(params = {})
    super(params)
    @key = params[:key]
    @value = params[:value]
  end
end
