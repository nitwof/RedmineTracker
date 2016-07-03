class BaseResource < ActiveResource::Base
  self.format = JsonFormatter.new(:collection_name)
  self.include_root_in_json = true

  def self.load_settings
    self.site = Settings.url
    TimeEntryActivity.site = Settings.url
    self.user = Settings.username
    self.password = Settings.password
    load_api_key
  end

  def self.load_api_key
    headers['X-Redmine-API-Key'] = Settings.api_key
    Issue.headers['X-Redmine-API-Key'] = Settings.api_key
    Project.headers['X-Redmine-API-Key'] = Settings.api_key
    TimeEntry.headers['X-Redmine-API-Key'] = Settings.api_key
    TimeEntryActivity.headers['X-Redmine-API-Key'] = Settings.api_key
    User.headers['X-Redmine-API-Key'] = Settings.api_key
  end

  def self.safe_find(*arguments)
    find(*arguments)
  rescue SocketError
    nil
  end

  def self.safe_all(*args)
    all(*args)
  rescue SocketError
    []
  end

  def self.safe_where(clauses = {})
    where(clauses)
  rescue SocketError
    []
  end

  def serialize
    as_json.symbolize_keys
  end
end
