# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  remote_id  :integer          not null
#  first_name :string
#  last_name  :string
#  email      :string
#  api_key    :string           not null
#  created_on :datetime
#  profile_id :integer
#
# Indexes
#
#  index_users_on_profile_id                (profile_id)
#  index_users_on_profile_id_and_remote_id  (profile_id,remote_id) UNIQUE
#  index_users_on_remote_id                 (remote_id)
#

class User < ActiveRecord::Base
  belongs_to :profile

  validates :remote_id, :email, :api_key, uniqueness: { scope: :profile }
  validates :remote_id, :profile, :api_key, presence: true
end
