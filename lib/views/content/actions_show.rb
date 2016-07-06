class ActionsShow < Qt::Widget
  attr_reader :timer

  signals :socket_error

  def initialize(parent = nil, width = 0, height = 0)
    super(parent)
    setMinimumWidth(width) if width.present?
    setMinimumHeight(height) if height.present?
    init_ui
  end

  def init_ui
    layout = Qt::VBoxLayout.new(self)
    layout.setContentsMargins(10, 0, 0, 80)

    layout.addWidget init_project_ui
    layout.addWidget init_issue_ui
    layout.addWidget init_activity_ui
    layout.addWidget init_time_from_start_ui
    layout.addWidget init_spent_on_ui

    @timer = Qt::Timer.new(self)
    @timer.setInterval(5000)
  end

  def create_label(name)
    label = Qt::Label.new(name, self)
    label.setFont Qt::Font.new('Arial', 16)
    label.resize(width, 20)
    label.setWordWrap true
    label
  end

  def init_project_ui
    @project = create_label('Project:')
  end

  def init_issue_ui
    @issue = create_label('Issue:')
  end

  def init_activity_ui
    @activity = create_label('Activity:')
  end

  def init_time_from_start_ui
    @time_from_start = Qt::Label.new('0.0', self)
    @time_from_start.setFont Qt::Font.new('Arial', 130, Qt::Font::Bold)
    @time_from_start.setAlignment(Qt::AlignCenter)
    @time_from_start
  end

  def init_spent_on_ui
    @spent_on = Qt::Label.new('0.0', self)
    @spent_on.setFont Qt::Font.new('Arial', 50)
    @spent_on.setAlignment(Qt::AlignCenter)
    @spent_on
  end

  def show_action(action)
    begin
      @project.text = "Project: #{action.project.try(:name)}"
      @issue.text = "Issue: #{action.issue.try(:subject)}"
      @activity.text = "Activity: #{action.activity.try(:name)}"
    rescue SocketError
      socket_error
    end
    refresh_timestamps(action)
    action.started? ? @timer.start : @timer.stop
  end

  def refresh_timestamps(action)
    if action.started?
      @time_from_start.text = action.time_from_start.to_s
      @spent_on.text = (action.spent_on + action.time_from_start).round(2).to_s
    else
      @time_from_start.text = '0.0'
      @spent_on.text = action.spent_on.round(2).to_s
    end
  end

  def to_offline
    @project.text = ''
    @issue.text = ''
    @activity.text = ''
  end
end
