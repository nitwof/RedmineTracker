# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  remote_id   :integer          not null
#  name        :string           not null
#  identifier  :string
#  description :text
#  status      :integer
#  created_on  :datetime
#  updated_on  :datetime
#  profile_id  :integer
#  parent_id   :integer
#
# Indexes
#
#  index_projects_on_parent_id                 (parent_id)
#  index_projects_on_profile_id                (profile_id)
#  index_projects_on_profile_id_and_remote_id  (profile_id,remote_id) UNIQUE
#  index_projects_on_remote_id                 (remote_id)
#

class Project < ActiveRecord::Base
  belongs_to :profile
  belongs_to :parent, class_name: 'Project'

  has_many :children, class_name: 'Project', foreign_key: :parent_id
  has_many :issues
  has_many :time_entries

  validates :remote_id, uniqueness: { scope: :profile }
  validates :remote_id, :profile, :name, presence: true
end
