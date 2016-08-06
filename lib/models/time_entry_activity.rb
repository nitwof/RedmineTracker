# == Schema Information
#
# Table name: time_entry_activities
#
#  id         :integer          not null, primary key
#  remote_id  :integer          not null
#  name       :string           not null
#  profile_id :integer
#
# Indexes
#
#  index_time_entry_activities_on_profile_id                (profile_id)
#  index_time_entry_activities_on_profile_id_and_remote_id  (profile_id,remote_id) UNIQUE
#  index_time_entry_activities_on_remote_id                 (remote_id)
#

class TimeEntryActivity < ActiveRecord::Base
  belongs_to :profile

  has_many :time_entries

  validates :remote_id, uniqueness: { scope: :profile }
  validates :remote_id, :profile, :name, presence: true
end
