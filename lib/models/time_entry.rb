# == Schema Information
#
# Table name: time_entries
#
#  id                     :integer          not null, primary key
#  remote_id              :integer          not null
#  hours                  :float            not null
#  comments               :string
#  spent_on               :date             not null
#  created_on             :datetime
#  updated_on             :datetime
#  profile_id             :integer
#  project_id             :integer
#  issue_id               :integer
#  time_entry_activity_id :integer
#
# Indexes
#
#  index_time_entries_on_issue_id                  (issue_id)
#  index_time_entries_on_profile_id                (profile_id)
#  index_time_entries_on_profile_id_and_remote_id  (profile_id,remote_id) UNIQUE
#  index_time_entries_on_project_id                (project_id)
#  index_time_entries_on_remote_id                 (remote_id)
#  index_time_entries_on_time_entry_activity_id    (time_entry_activity_id)
#

class TimeEntry < ActiveRecord::Base
  belongs_to :profile
  belongs_to :project
  belongs_to :issue
  belongs_to :activity, class_name: 'TimeEntryActivity'

  validates :remote_id, uniqueness: { scope: :profile }
  validates :remote_id, :profile, :hours, :spent_on,
            :activity, :issue, :project, presence: true
end
