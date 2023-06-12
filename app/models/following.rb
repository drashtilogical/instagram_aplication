class Following < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed_user, class_name: 'User'
  validates_uniqueness_of :follower_id, scope: :followed_user_id
end
