class User < BaseResource
  def self.current
    find(:current)
  end
end
