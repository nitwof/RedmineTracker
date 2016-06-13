class BaseResource < ActiveResource::Base
  self.format = JsonFormatter.new(:collection_name)
  self.include_root_in_json = true

  def self.load_settings
    self.site = Settings.url
    TimeEntryActivity.site = Settings.url
    self.user = Settings.username
    self.password = Settings.password
    headers['X-Redmine-API-Key'] = Settings.api_key
  end

  def serialize
    as_json.symbolize_keys
  end
end
