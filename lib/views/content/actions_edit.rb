class ActionsEdit < Qt::Widget
  attr_reader :name_edit, :project_edit, :issue_edit, :activity_edit

  slots 'project_selected(int)'

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
    layout.addWidget init_activity_edit_ui

    connect(@project_edit.widget, SIGNAL('currentIndexChanged(int)'),
            self, SLOT('project_selected(int)'))
  end

  def init_name_edit_ui
    name_label = Qt::Label.new('Name:', self)
    name_label.setFont Qt::Font.new('Arial', 16)
    @name_edit = FormLine.new(Qt::LineEdit.new, name_label,
                              self, width - 10, 50)
    @name_edit
  end

  def init_project_edit_ui
    project_label = Qt::Label.new('Project:', self)
    project_label.setFont Qt::Font.new('Arial', 16)
    @project_edit = FormLine.new(Qt::ComboBox.new, project_label,
                                 self, width - 10, 50)
    @project_edit
  end

  def init_issue_edit_ui
    issue_label = Qt::Label.new('Issue:', self)
    issue_label.setFont Qt::Font.new('Arial', 16)
    @issue_edit = FormLine.new(Qt::ComboBox.new, issue_label,
                               self, width - 10, 50)
    @issue_edit
  end

  def init_activity_edit_ui
    activity_label = Qt::Label.new('Activity:', self)
    activity_label.setFont Qt::Font.new('Arial', 16)
    @activity_edit = FormLine.new(Qt::ComboBox.new, activity_label,
                                  self, width - 10, 50)
    @activity_edit
  end

  def init_models
    Project.all.each do |project|
      @project_edit.widget.addItem(project.name, Qt::Variant.new(project.id))
    end
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
    index = @issue_edit.widget.currentIndex
    @issue_edit.widget.itemData(index).to_i
  end

  def activity_id
    index = @activity_edit.widget.currentIndex
    @activity_edit.widget.itemData(index).to_i
  end

  protected

  def project_selected(index)
    project_id = sender.itemData(index).to_i
    @issue_edit.widget.clear
    Issue.where(project_id: project_id).each do |issue|
      @issue_edit.widget.addItem(issue.subject, Qt::Variant.new(issue.id))
    end
  end
end
