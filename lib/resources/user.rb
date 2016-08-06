module Resource
  class User < Base
  def self.current
    find(:current)
  end

  def name
    "#{firstname} #{lastname}"
  end
  end
end
