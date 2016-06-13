require 'Qt'

class Application < Qt::Widget
  slots :open_settings

  def initialize(screen)
    super(nil)
    setWindowTitle 'Redmine Tracker'
    setFixedSize(800, 600)
    move(screen.rect.center - rect.center)
    BaseResource.load_settings
    open_settings unless connected?
    init_ui
    connect_ui
    show
  end

  def init_ui
    layout = Qt::HBoxLayout.new(self)
    layout.setSpacing(0)
    layout.setContentsMargins(0, 0, 0, 0)
    @sidebar = Sidebar.new(self, 300, 600)
    @content = Content.new(self, 500, 600)
    layout.addWidget @sidebar
    layout.addWidget @content
  end

  def connect_ui
    connect_actions_list_ui
    connect(@sidebar.footer.add_button, SIGNAL(:clicked),
            @content, SLOT(:to_new))
    connect(@sidebar.user_card, SIGNAL(:clicked), self, SLOT(:open_settings))
  end

  def connect_actions_list_ui
    connect(@sidebar.actions_list, SIGNAL('action_chosen(QString)'),
            @content, SLOT('show_action(QString)'))
    connect(@content, SIGNAL('action_changed(QString)'),
            @sidebar.actions_list, SLOT('refresh(QString)'))
  end

  def check_connection
    User.current.present?
  rescue
    false
  end

  def connected?
    check_connection
  end

  def refresh
    @sidebar.refresh if @sidebar.present?
    @content.refresh if @content.present?
  end

  protected

  def open_settings
    loop do
      result = SettingsWindow.new(self, 500, 400).exec
      BaseResource.load_settings
      if connected?
        refresh if result == 1
        return
      end
      exit(0) if result == 0
    end
  end
end
