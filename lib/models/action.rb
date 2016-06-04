require 'models/base_model'

class Action < BaseModel
  @store = Store::YAML.instance
  @table = 'actions'

  attr_accessor :name, :started_at, :stopped_at,
                :project_id, :issue_id

  def initialize(params = {})
    super(params)
    @name = params[:name]
    @started_at = params[:started_at]
    @stopped_at = params[:stopped_at]
    @project_id = params[:project_id]
    @issue_id = params[:issue_id]
  end

  def project
    @project ||= Project.find(@project_id) if @project_id.present?
  end

  def issue
    @issue ||= Issue.find(@issue_id) if @issue_id.present?
  end
end
