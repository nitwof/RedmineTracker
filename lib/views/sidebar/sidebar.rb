class Sidebar < Qt::Widget
  attr_reader :actions_list, :footer, :user_card

  signals :socket_error
  slots :handle_socket_error

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
    layout.addWidget init_user_card_ui
    layout.addWidget init_actions_list_ui
    layout.addWidget init_footer_ui
    connect_widgets
  end

  def init_user_card_ui
    @user_card = UserCard.new(self, width, 100)
  end

  def init_actions_list_ui
    @actions_list = ActionsList.new(self, width, height - 150)
  end

  def init_footer_ui
    @footer = SidebarFooter.new(self, width, 50)
  end

  def connect_widgets
    connect(@user_card, SIGNAL(:socket_error),
            self, SLOT(:handle_socket_error))
  end

  def refresh
    @user_card.refresh
    @actions_list.refresh(nil)
  end

  def to_online
    refresh
    @footer.to_online
  end

  def to_offline
    @user_card.to_offline
    @footer.to_offline
  end

  protected

  def handle_socket_error
    socket_error
  end
end
