class ActionButton < Qt::PushButton
  attr_reader :id

  def initialize(action, parent)
    super(action.name, parent)
    @id = action.id
  end

  def action=(action)
    self.text = action.name
    @id = action.id
  end

  def action
    Action.find(@id)
  end
end
