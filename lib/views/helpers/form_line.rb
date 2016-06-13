class FormLine < Qt::Widget
  attr_accessor :label, :widget

  def initialize(widget, label = nil, parent = nil, width = 0, height = 0)
    super(parent)
    setMinimumWidth(width) if width.present?
    setMinimumHeight(height) if height.present?
    @widget = widget
    @widget.parent = self
    @label = label
    init_ui
  end

  def init_ui
    layout = Qt::HBoxLayout.new(self)
    @widget.resize(width, height)
    @widget.setMinimumWidth(width - @label.width - 10)
    layout.addWidget @label
    layout.addWidget @widget
  end
end
