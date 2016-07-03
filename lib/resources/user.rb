class User < BaseResource
  def self.current
    find(:current)
  end

  def self.safe_current
    safe_find(:current)
  end

  def name
    "#{firstname} #{lastname}"
  end
end
