class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :photos
  has_many :likes
  has_many :followings, foreign_key: :follower_id, dependent: :destroy
  has_many :followed_users, through: :followings, source: :followed_user

  has_many :reverse_followings, foreign_key: :followed_user_id, class_name: 'Following', dependent: :destroy
  has_many :followers, through: :reverse_followings, source: :follower

  has_many :following, through: :followings, source: :followed_user

  has_many :sent_follow_requests, foreign_key: :sender_id, class_name: 'FollowRequest', dependent: :destroy
  has_many :received_follow_requests, foreign_key: :receiver_id, class_name: 'FollowRequest', dependent: :destroy

  def following_count
    followings.count
  end

  def pending_follow_requests
    received_follow_requests.where(status: 'pending')
  end
  
end
