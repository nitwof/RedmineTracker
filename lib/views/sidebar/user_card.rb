class UserCard < Qt::PushButton
  signals :socket_error

  def initialize(parent = nil, width = 0, height = 0)
    super(parent)
    load_user
    setMinimumWidth(width) if width.present?
    setMinimumHeight(height) if height.present?
    init_ui
  end

  def init_ui
    layout = Qt::VBoxLayout.new(self)
    @name = Qt::Label.new(@user.try(:name), self)
    @mail = Qt::Label.new(@user.try(:mail), self)
    @name.setAlignment(Qt::AlignCenter | Qt::AlignBottom)
    @name.setFont Qt::Font.new('Arial', 14, Qt::Font::Bold)
    @name.setStyleSheet 'QLabel { color: black }'
    @mail.setAlignment(Qt::AlignCenter)
    layout.addWidget @name
    layout.addWidget @mail
  end

  def refresh
    load_user
    @name.text = @user.try(:name)
    @mail.text = @user.try(:mail)
  end

  def load_user
    @user = User.current
  rescue SocketError
    socket_error
  end

  def to_offline
    @name.text = 'Offline mode'
    @mail.text = 'Connection problem with Redmine'
  end
end
