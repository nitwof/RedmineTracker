class ActionsEdit < Qt::Widget
  attr_reader :name_edit, :project_edit, :issue_edit, :activity_edit

  signals :socket_error
  slots 'issue_edit_finished(QString)'

  def initialize(parent = nil, width = 0, height = 0)
    super(parent)
    setMinimumWidth(width) if width.present?
    setMinimumHeight(height) if height.present?
    init_ui
    init_models
  end

  def init_ui
    layout = Qt::VBoxLayout.new(self)
    layout.setContentsMargins(10, 0, 0, 80)

    layout.addWidget init_name_edit_ui
    layout.addWidget init_project_edit_ui
    layout.addWidget init_issue_edit_ui
    layout.addWidget init_issue_helper_ui
    layout.addWidget init_activity_edit_ui

    connect_ui
  end

  def connect_ui
    connect(@issue_edit.widget, SIGNAL('textChanged(QString)'),
            self, SLOT('issue_edit_finished(QString)'))
  end

  def init_name_edit_ui
    name_label = Qt::Label.new('Name:', self)
    name_label.setFont Qt::Font.new('Arial', 16)
    @name_edit = FormLine.new(Qt::LineEdit.new, name_label,
                              self, width - 10, 50)
  end

  def init_project_edit_ui
    project_label = Qt::Label.new('Project:', self)
    project_label.setFont Qt::Font.new('Arial', 16)
    @project_edit = FormLine.new(Qt::ComboBox.new, project_label,
                                 self, width - 10, 50)
  end

  def init_issue_edit_ui
    issue_label = Qt::Label.new('Issue:', self)
    issue_label.setFont Qt::Font.new('Arial', 16)
    issue_line = Qt::LineEdit.new
    issue_line.setValidator Qt::IntValidator.new(1, 999_999_999, self)
    @issue_edit = FormLine.new(issue_line, issue_label,
                               self, width - 10, 50)
  end

  def init_issue_helper_ui
    @issue_helper = Qt::Label.new(self)
    @issue_helper.setFont Qt::Font.new('Arial', 14)
    @issue_helper.setStyleSheet 'QLabel { color: black }'
    @issue_helper.setMinimumWidth(width - 10)
    @issue_helper
  end

  def init_activity_edit_ui
    activity_label = Qt::Label.new('Activity:', self)
    activity_label.setFont Qt::Font.new('Arial', 16)
    @activity_edit = FormLine.new(Qt::ComboBox.new, activity_label,
                                  self, width - 10, 50)
  end

  def init_models
    init_projects
    init_activities
  rescue SocketError
    socket_error
  end

  def init_projects
    Project.all.each do |project|
      @project_edit.widget.addItem(project.name, Qt::Variant.new(project.id))
    end
  end

  def init_activities
    TimeEntryActivity.all.each do |activity|
      @activity_edit.widget.addItem(activity.name, Qt::Variant.new(activity.id))
    end
  end

  def show_action(action)
    @name_edit.widget.text = action.name
    @project_edit.widget.currentText = action.project_id
  end

  def name
    @name_edit.widget.text
  end

  def project_id
    index = @project_edit.widget.currentIndex
    @project_edit.widget.itemData(index).to_i
  end

  def issue_id
    issue_id = @issue_edit.widget.text
    issue_id.to_i if Issue.safe_find(issue_id).present?
  end

  def activity_id
    index = @activity_edit.widget.currentIndex
    @activity_edit.widget.itemData(index).to_i
  end

  def to_online
    @project_edit.widget.setEnabled true
    @issue_edit.widget.setEnabled true
    @activity_edit.widget.setEnabled true
  end

  def to_offline
    @project_edit.widget.setEnabled false
    @issue_edit.widget.setEnabled false
    @activity_edit.widget.setEnabled false
  end

  def find_project_item(project_id)
    @project_edit.widget.count.times do |i|
      return i if @project_edit.widget.itemData(i).to_i == project_id.to_i
    end
    nil
  end

  protected

  def issue_edit_finished(issue_id)
    issue = Issue.safe_find(issue_id)
    @issue_helper.text = issue.try(:subject) || 'Issue not found'
    project_id = issue.try(:project).try(:id)
    project_item_id = find_project_item(project_id)
    return if project_item_id.nil?
    @project_edit.widget.currentIndex = project_item_id
  end
end
