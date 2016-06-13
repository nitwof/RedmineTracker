class ActionsEditFooter < Qt::Widget
  attr_reader :cancel_button, :save_button

  def initialize(parent = nil, width = 0, height = 0)
    super(parent)
    setMinimumWidth(width) if width.present?
    setMinimumHeight(height) if height.present?
    init_ui
  end

  def init_ui
    layout = Qt::HBoxLayout.new(self)
    layout.setContentsMargins(0, 0, 0, 0)
    @cancel_button = Qt::PushButton.new('Cancel', self)
    @save_button = Qt::PushButton.new('Save', self)
    @cancel_button.setMinimumHeight(height)
    @save_button.setMinimumHeight(height)
    layout.addWidget @cancel_button
    layout.addWidget @save_button
  end
end
