class BaseModel
  @store = Store::YAML.instance
  @table = :base

  attr_accessor :id, :created_at, :updated_at

  class << self
    attr_reader :store, :table

    def all
      store.select table || []
    end

    def find(id)
      store.find(table, id)
    end

    def select(params = {})
      store.select(table, params)
    end

    def create(params = {})
      new(params.merge(id: nil)).save
    end

    def destroy_all
      store.truncate table
    end
  end

  def initialize(params = {})
    @id = params[:id]
    @created_at = @updated_at = nil
  end

  def [](key)
    instance_variable_get("@#{key}")
  end

  def []=(key, value)
    instance_variable_set("@#{key}", value)
  end

  def save
    return create if @id.nil?
    update
  end

  def destroy
    self.class.store.delete(self.class.table, @id) if @id.present?
  end

  protected

  def create
    @created_at = @updated_at = Time.current
    self.class.store.insert(self.class.table, self)
  end

  def update
    @updated_at = Time.current
    self.class.store.update(self.class.table, id, self)
  end
end
