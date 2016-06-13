class Action < BaseModel
  @store = Store::YAML.instance
  @table = :actions

  attr_accessor :name, :started_at, :stopped_at, :spent_on,
                :project_id, :issue_id, :activity_id

  def initialize(params = {})
    super(params)
    @name = params[:name]
    @started_at = params[:started_at]
    @stopped_at = params[:stopped_at]
    @project_id = params[:project_id]
    @spent_on = params[:spent_on] || 0.0
    @issue_id = params[:issue_id]
    @activity_id = params[:activity_id]
  end

  def project
    return nil if @project_id.nil?
    Project.find(@project_id)
  end

  def issue
    return nil if @issue_id.nil?
    Issue.find(@issue_id)
  end

  def activity
    return nil if @activity_id.nil?
    TimeEntryActivity.find_by_id(@activity_id)
  end

  def started?
    @started_at.present? && @stopped_at.nil?
  end

  def start
    @started_at = Time.current
    @stopped_at = nil
  end

  def stop
    @stopped_at = Time.current
    @spent_on += spent_from_start
  end

  def time_from_start
    return 0.0 if started_at.nil?
    ((Time.current - @started_at) / 60 / 60).round(2)
  end

  def spent_from_start
    return 0.0 if started_at.nil? || stopped_at.nil?
    ((@stopped_at - @started_at) / 60 / 60).round(2)
  end

  def create_time_entry
    return if spent_from_start == 0.0
    TimeEntry.create(issue_id: @issue_id, hours: time_from_start,
                     comments: @name.force_encoding('UTF-8'),
                     activity_id: @activity_id)
  end
end
