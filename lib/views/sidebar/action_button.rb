class ActionButton < Qt::PushButton
  attr_reader :id

  def initialize(action, parent)
    super(parent)
    @id = action.id
    init_ui(action)
  end

  def action=(action)
    @label.text = action.name
    @id = action.id
  end

  def action
    Action.find(@id)
  end

  protected

  def init_ui(action)
    layout = Qt::VBoxLayout.new(self)
    @label = Qt::Label.new(action.name, self)
    @label.setAlignment(Qt::AlignCenter | Qt::AlignCenter)
    @label.setWordWrap true
    layout.addWidget @label
  end
end
