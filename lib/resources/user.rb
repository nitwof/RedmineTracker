class User < BaseResource
  def self.current
    find(:current)
  end

  def name
    "#{firstname} #{lastname}"
  end
end
