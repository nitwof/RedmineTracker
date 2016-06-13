class Sidebar < Qt::Widget
  attr_reader :actions_list, :footer, :user_card

  def initialize(parent = nil, width = 0, height = 0)
    super(parent)
    setMinimumWidth(width) if width.present?
    setMinimumHeight(height) if height.present?
    init_ui
  end

  def init_ui
    layout = Qt::VBoxLayout.new(self)
    layout.setSpacing(0)
    layout.setContentsMargins(0, 0, 0, 0)
    @user_card = UserCard.new(self, width, 100)
    @actions_list = ActionsList.new(self, width, height - 150)
    @footer = SidebarFooter.new(self, width, 50)
    layout.addWidget @user_card
    layout.addWidget @actions_list
    layout.addWidget @footer
  end

  def refresh
    @user_card.refresh
    @actions_list.refresh(nil)
  end
end
