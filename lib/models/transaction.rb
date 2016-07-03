class Transaction < BaseModel
  @store = Store::YAML.instance
  @table = :transactions

  def self.save_action(action)
    Transaction.new(issue_id: action.issue_id,
                    hours: action.time_from_start,
                    comments: action.name.force_encoding('UTF-8'),
                    activity_id: action.activity_id)
  end

  def self.handle_all
    Transaction.all.each do |t|
      t.destroy.handle
    end
  end

  def initialize(params = {})
    super(params)
    @issue_id = params[:issue_id]
    @hours = params[:hours]
    @comments = params[:comments]
    @activity_id = params[:activity_id]
  end

  def handle
    TimeEntry.create(issue_id: @issue_id, hours: @hours,
                     comments: @comments, activity_id: @activity_id)
  end
end
