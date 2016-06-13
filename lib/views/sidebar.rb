class Sidebar < FXVerticalFrame
  def initialize(p)
    super(p)
    init_ui
  end

  def init_ui
    UserCard.new(self)
  end
end
