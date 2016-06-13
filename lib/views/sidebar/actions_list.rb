class ActionsList < Qt::ListWidget
  signals 'action_chosen(QString)'
  slots :action_clicked, 'refresh(QString)'

  def initialize(parent = nil, width = 0, height = 0)
    super(parent)
    setMinimumWidth(width) if width.present?
    setMinimumHeight(height) if height.present?
    setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff)
    setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff)
    init_ui
  end

  def init_ui
    Action.all.reverse.each do |action|
      action_button = ActionButton.new(action, self)
      item = Qt::ListWidgetItem.new
      item.sizeHint = Qt::Size.new(item.sizeHint.width, 50)
      insertItem(0, item)
      setItemWidget(item, action_button)
      connect(action_button, SIGNAL(:clicked), self, SLOT(:action_clicked))
    end
  end

  # rubocop:disable Lint/UnusedMethodArgument
  def refresh(action_id)
    clear
    init_ui
  end
  # rubocop:enable Lint/UnusedMethodArgument

  protected

  def action_clicked
    action_chosen(sender.id)
  end
end
