require 'Qt'

class Application < Qt::Widget
  slots :open_settings, :to_online, :to_offline

  def initialize(screen)
    super
    setWindowTitle 'Redmine Tracker'
    setFixedSize(800, 600)
    move(screen.rect.center - rect.center)
    init
    init_ui
    connect_ui
    to_offline unless connected?
    show
  end

  def init
    BaseResource.load_settings
    open_settings unless Settings.url.present? && authorized?
    handle_transactions
  end

  def init_ui
    layout = Qt::HBoxLayout.new(self)
    layout.setSpacing(0)
    layout.setContentsMargins(0, 0, 0, 0)
    @sidebar = Sidebar.new(self, 300, 600)
    @content = Content.new(self, 500, 600)
    layout.addWidget @sidebar
    layout.addWidget @content

    @connection_timer = Qt::Timer.new(self)
    @connection_timer.setInterval(5000)
  end

  def connect_ui
    connect_actions_list_ui
    connect(@sidebar.footer.add_button, SIGNAL(:clicked),
            @content, SLOT(:to_new))
    connect(@sidebar.user_card, SIGNAL(:clicked), self, SLOT(:open_settings))

    connect(@connection_timer, SIGNAL(:timeout), self, SLOT(:to_online))

    connect_socket_error
  end

  def connect_socket_error
    connect(@sidebar, SIGNAL(:socket_error), self, SLOT(:to_offline))
    connect(@content, SIGNAL(:socket_error), self, SLOT(:to_offline))
  end

  def connect_actions_list_ui
    connect(@sidebar.actions_list, SIGNAL('action_chosen(QString)'),
            @content, SLOT('show_action(QString)'))
    connect(@content, SIGNAL('action_changed(QString)'),
            @sidebar.actions_list, SLOT('refresh(QString)'))
  end

  def connected?
    User.current
    true
  rescue ActiveResource::UnauthorizedAccess
    true
  rescue SocketError
    false
  end

  def authorized?
    User.current.present?
  rescue SocketError
    true
  rescue ActiveResource::UnauthorizedAccess
    false
  end

  def refresh
    @sidebar.refresh if @sidebar.present?
    @content.refresh if @content.present?
  end

  def to_online
    return unless connected?
    @connection_timer.stop
    open_settings unless Settings.url.present? && authorized?
    return unless handle_transactions
    @sidebar.to_online
    @content.to_online
  end

  def to_offline
    @sidebar.to_offline
    @content.to_offline
    @connection_timer.start
  end

  def handle_transactions
    Transaction.handle_all
    true
  rescue
    to_offline
    false
  end

  protected

  def open_settings
    loop do
      result = SettingsWindow.new(self, 500, 400).exec
      BaseResource.load_settings
      if Settings.url.present? && authorized?
        refresh if result == 1
        return
      end
      exit(0) if result == 0
    end
  end
end
