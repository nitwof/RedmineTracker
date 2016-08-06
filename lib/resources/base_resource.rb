module Resource
  class Base < ActiveResource::Base
    self.format = JsonFormatter.new(:collection_name)
    self.include_root_in_json = true

    # def self.load_settings
    #   self.site = Settings.url
    #   TimeEntryActivity.site = Settings.url
    #   self.user = Settings.username
    #   self.password = Settings.password
    #   load_api_key
    # end
    #
    # def self.load_api_key
    #   headers['X-Redmine-API-Key'] = Settings.api_key
    #   Issue.headers['X-Redmine-API-Key'] = Settings.api_key
    #   Project.headers['X-Redmine-API-Key'] = Settings.api_key
    #   TimeEntry.headers['X-Redmine-API-Key'] = Settings.api_key
    #   TimeEntryActivity.headers['X-Redmine-API-Key'] = Settings.api_key
    #   User.headers['X-Redmine-API-Key'] = Settings.api_key
    # end

    def serialize
      as_json.symbolize_keys
    end
  end
end

