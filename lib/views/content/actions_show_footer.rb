class ActionsShowFooter < Qt::Widget
  attr_reader :start_button, :stop_button, :edit_button

  def initialize(parent = nil, width = 0, height = 0)
    super(parent)
    setMinimumWidth(width) if width.present?
    setMinimumHeight(height) if height.present?
    init_ui
  end

  def init_ui
    layout = Qt::HBoxLayout.new(self)
    layout.setContentsMargins(0, 0, 0, 0)

    init_buttons_ui

    layout.addWidget @start_button
    layout.addWidget @stop_button
    layout.addWidget @edit_button
  end

  def init_buttons_ui
    @start_button = Qt::PushButton.new('Start', self)
    @stop_button = Qt::PushButton.new('Stop', self)
    @edit_button = Qt::PushButton.new('Edit', self)
    @start_button.setMinimumHeight(height)
    @stop_button.setMinimumHeight(height)
    edit_button.setMinimumHeight(height)
  end

  def show_action(action)
    if action.started?
      @start_button.hide
      @stop_button.show
    else
      @start_button.show
      @stop_button.hide
    end
  end
end
