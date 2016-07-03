class SidebarFooter < Qt::Widget
  attr_reader :add_button

  def initialize(parent = nil, width = 0, height = 0)
    super(parent)
    setMinimumWidth(width) if width.present?
    setMinimumHeight(height) if height.present?
    init_ui
  end

  def init_ui
    layout = Qt::HBoxLayout.new(self)
    layout.setContentsMargins(0, 0, 0, 0)
    @add_button = Qt::PushButton.new('Add', self)
    @add_button.setMinimumHeight(height)
    layout.addWidget @add_button
  end

  def to_online
    @add_button.setEnabled true
  end

  def to_offline
    @add_button.setEnabled false
  end
end
