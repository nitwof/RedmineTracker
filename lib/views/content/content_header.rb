class ContentHeader < Qt::Widget
  def initialize(parent = nil, width = 0, height = 0)
    super(parent)
    setMinimumWidth(width) if width.present?
    setMinimumHeight(height) if height.present?
    setStyleSheet 'QWidget { border-bottom: 2px solid black }'
    init_ui
  end

  def init_ui
    layout = Qt::HBoxLayout.new(self)
    @header = Qt::Label.new(self)
    @header.setAlignment(Qt::AlignCenter | Qt::AlignCenter)
    @header.setFont Qt::Font.new('Arial', 15, Qt::Font::Bold)
    @header.setStyleSheet 'QLabel { color: black }'
    layout.addWidget @header
  end

  def title=(title)
    @header.text = title
  end

  def title
    @header.text
  end
end
