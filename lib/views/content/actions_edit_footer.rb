class ActionsEditFooter < Qt::Widget
  attr_reader :cancel_button, :delete_button, :save_button

  def initialize(parent = nil, width = 0, height = 0)
    super(parent)
    setMinimumWidth(width) if width.present?
    setMinimumHeight(height) if height.present?
    init_ui
  end

  def init_ui
    layout = Qt::HBoxLayout.new(self)
    layout.setContentsMargins(0, 0, 0, 0)

    @cancel_button = create_button('Cancel')
    @delete_button = create_button('Delete')
    @save_button = create_button('Save')

    layout.addWidget @cancel_button
    layout.addWidget @delete_button
    layout.addWidget @save_button
  end

  private

  def create_button(text)
    button = Qt::PushButton.new(text, self)
    button.setMinimumHeight(height)
    button
  end
end
