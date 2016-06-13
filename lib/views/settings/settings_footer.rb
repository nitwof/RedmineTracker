class SettingsFooter < Qt::Widget
  attr_reader :cancel_button, :save_button

  def initialize(parent = nil, width = 0, height = 0)
    super(parent)
    setMinimumWidth(width) if width.present?
    setMinimumHeight(height) if height.present?
    init_ui
  end

  protected

  def init_ui
    layout = Qt::HBoxLayout.new(self)

    layout.addWidget init_cancel_button_ui
    layout.addWidget init_save_button_ui
  end

  def init_cancel_button_ui
    @cancel_button = Qt::PushButton.new('Cancel', self)
    @cancel_button.setMinimumHeight(height)
    @cancel_button
  end

  def init_save_button_ui
    @save_button = Qt::PushButton.new('Save', self)
    @save_button.setMinimumHeight(height)
    @save_button
  end
end
