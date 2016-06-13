class MainWindow < FXMainWindow
  def initialize(app, title, width = 0, height = 0)
    super(app, title, nil, nil, DECOR_ALL, 0, 0, width, height)
    init_ui
  end

  def init_ui
    Sidebar.new(self)
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end
end
