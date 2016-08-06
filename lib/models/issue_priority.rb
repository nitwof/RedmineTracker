# == Schema Information
#
# Table name: issue_priorities
#
#  id         :integer          not null, primary key
#  remote_id  :integer          not null
#  name       :string
#  default    :boolean          default(FALSE), not null
#  profile_id :integer
#
# Indexes
#
#  index_issue_priorities_on_profile_id                (profile_id)
#  index_issue_priorities_on_profile_id_and_remote_id  (profile_id,remote_id) UNIQUE
#  index_issue_priorities_on_remote_id                 (remote_id)
#

class IssuePriority < ActiveRecord::Base
  belongs_to :profile

  has_many :issues

  validates :remote_id, uniqueness: { scope: :profile }
  validates :remote_id, :profile, :name, presence: true
end
