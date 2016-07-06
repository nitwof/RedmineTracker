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
    layout.addWidget init_name_ui
    layout.addWidget init_mail_ui
  end

  def init_name_ui
    @name = Qt::Label.new(@user.try(:name), self)
    @name.setAlignment(Qt::AlignCenter | Qt::AlignBottom)
    @name.setFont Qt::Font.new('Arial', 14, Qt::Font::Bold)
    @name.setStyleSheet 'QLabel { color: black }'
    @name.setWordWrap true
    @name
  end

  def init_mail_ui
    @mail = Qt::Label.new(@user.try(:mail), self)
    @mail.setAlignment(Qt::AlignCenter)
    @mail.setWordWrap true
    @mail
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
