class SettingsWindow < Qt::Dialog
  slots :save_settings

  def initialize(parent = nil, width = 100, height = 100)
    super(parent)
    resize(width, height)
    init_ui
    connect_buttons
    set_defaults
  end

  def url
    @url_edit.widget.text
  end

  def api_key
    @api_key_edit.widget.text
  end

  def username
    @username_edit.widget.text if @username_edit.widget.text != ''
  end

  def password
    @password_edit.widget.text if @password_edit.widget.text != ''
  end

  def set_defaults
    @url_edit.widget.text = Settings.url
    @api_key_edit.widget.text = Settings.api_key
    @username_edit.widget.text = Settings.username
    @password_edit.widget.text = Settings.password
  end

  protected

  def init_ui
    layout = Qt::VBoxLayout.new(self)

    layout.addWidget init_url_edit_ui
    layout.addWidget init_api_key_edit_ui
    layout.addWidget init_username_edit_ui
    layout.addWidget init_password_edit_ui
    layout.addWidget init_footer_ui
  end

  def connect_buttons
    connect(@footer.cancel_button, SIGNAL(:clicked),
            self, SLOT(:reject))
    connect(@footer.save_button, SIGNAL(:clicked),
            self, SLOT(:save_settings))
  end

  def create_input(name)
    label = Qt::Label.new(name, self)
    label.setFont Qt::Font.new('Arial', 16)
    FormLine.new(Qt::LineEdit.new, label,
                 self, width - 10, 50)
  end

  def init_url_edit_ui
    @url_edit = create_input('URL *')
  end

  def init_api_key_edit_ui
    @api_key_edit = create_input('API Key *')
  end

  def init_username_edit_ui
    @username_edit = create_input('Username')
  end

  def init_password_edit_ui
    @password_edit = create_input('Password')
  end

  def init_footer_ui
    @footer = SettingsFooter.new(self, width, 50)
  end

  def save_settings
    Settings.url = url
    Settings.api_key = api_key
    Settings.username = username
    Settings.password = password
    accept
  end
end
