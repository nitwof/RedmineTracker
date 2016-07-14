class ActionsList < Qt::ListWidget
  signals 'action_chosen(QString)'
  slots 'action_clicked(QListWidgetItem*, QListWidgetItem*)',
        'refresh(QString)',
        'action_moved(QModelIndex, int, int, QModelIndex, int)'

  def initialize(parent = nil, width = 0, height = 0)
    super(parent)
    setMinimumWidth(width) if width.present?
    setMinimumHeight(height) if height.present?
    setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff)
    setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff)
    setDragDropMode(Qt::AbstractItemView::InternalMove)
    init_ui
    reset_selection
    connect_ui
  end

  def init_ui
    Action.all.reverse.each do |action|
      add_action(action)
    end
  end

  def add_action(action)
    label = Qt::Label.new(action.name, self)
    label.setAlignment(Qt::AlignCenter | Qt::AlignCenter)
    label.setWordWrap true

    item = Qt::ListWidgetItem.new
    item.sizeHint = Qt::Size.new(item.sizeHint.width, 50)
    item.setData(Qt::UserRole, Qt::Variant.new(action.id))

    insertItem(0, item)
    setItemWidget(item, label)
  end

  def connect_ui
    connect(self,
            SIGNAL('currentItemChanged(QListWidgetItem*, QListWidgetItem*)'),
            self, SLOT('action_clicked(QListWidgetItem*, QListWidgetItem*)'))
    connect(model,
            SIGNAL('rowsMoved(QModelIndex, int, int, QModelIndex, int)'),
            self, SLOT('action_moved(QModelIndex, int, int, QModelIndex, int)'))
  end

  def reset_selection
    return if count == 0
    setCurrentItem(item(0))
  end

  def refresh(_action_id)
    clear
    init_ui
  end

  protected

  def action_clicked(current, _previous)
    return action_chosen(nil) if current.nil?
    action_id = current.data(Qt::UserRole).toString
    action_chosen(action_id)
  end

  def action_moved(src_parent, src_start, src_end, dst_parent, dst_row)
    item(dst_row)
    p "#{src_parent} #{src_start} #{src_end} #{dst_parent} #{dst_row}"
  end
end
