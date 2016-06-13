class UserCard < Qt::PushButton
  def initialize(parent = nil, width = 0, height = 0)
    super(parent)
    @user = User.current
    setMinimumWidth(width) if width.present?
    setMinimumHeight(height) if height.present?
    init_ui
  end

  def init_ui
    layout = Qt::VBoxLayout.new(self)
    @name = Qt::Label.new(@user.name, self)
    @mail = Qt::Label.new(@user.mail, self)
    @name.setAlignment(Qt::AlignCenter | Qt::AlignBottom)
    @name.setFont Qt::Font.new('Arial', 14, Qt::Font::Bold)
    @name.setStyleSheet 'QLabel { color: black }'
    @mail.setAlignment(Qt::AlignCenter)
    layout.addWidget @name
    layout.addWidget @mail
  end

  def refresh
    @user = User.current
    @name.text = @user.name
    @mail.text = @user.mail
  end
end
