# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  url        :string           not null
#  username   :string
#  password   :string
#  created_at :datetime
#  updated_at :datetime
#

class Profile < ActiveRecord::Base
  has_many :issues
  has_many :issue_priorities
  has_many :projects
  has_many :time_entries
  has_many :time_entry_activities
  has_many :users

  validates :name, uniqueness: true
  validates :name, :url, presence: true
end
