# == Schema Information
#
# Table name: issues
#
#  id                :integer          not null, primary key
#  remote_id         :integer          not null
#  subject           :string           not null
#  description       :text
#  start_date        :date
#  done_ratio        :integer
#  created_on        :datetime
#  updated_on        :datetime
#  profile_id        :integer
#  project_id        :integer
#  parent_id         :integer
#  issue_priority_id :integer
#
# Indexes
#
#  index_issues_on_issue_priority_id         (issue_priority_id)
#  index_issues_on_parent_id                 (parent_id)
#  index_issues_on_profile_id                (profile_id)
#  index_issues_on_profile_id_and_remote_id  (profile_id,remote_id) UNIQUE
#  index_issues_on_project_id                (project_id)
#  index_issues_on_remote_id                 (remote_id)
#

class Issue < ActiveRecord::Base
  belongs_to :profile
  belongs_to :project
  belongs_to :priority, class_name: 'IssuePriority'
  belongs_to :parent, class_name: 'Issue'

  has_many :children, class_name: 'Issue', foreign_key: :parent_id
  has_many :time_entries

  validates :remote_id, uniqueness: { scope: :profile }
  validates :remote_id, :profile, :subject, presence: true
end
