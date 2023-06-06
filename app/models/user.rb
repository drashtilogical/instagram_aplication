class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :photos
  has_many :likes
  has_many :comments
  has_many :followings, foreign_key: :follower_id, dependent: :destroy
  has_many :followed_users, through: :followings, source: :followed_user

  has_many :reverse_followings, foreign_key: :followed_user_id, class_name: 'Following', dependent: :destroy
  has_many :followers, through: :reverse_followings, source: :follower

  
  
  def following_count
    followings.count
  end

  def pending_follow_requests
    received_follow_requests.where(status: 'pending')
  end

  def following?(other_user)
    if other_user && following = followings.find_by(followed_user_id: other_user.id)
      true
    else
      false
    end
  end

  def follower(user)
    self.following << user unless self.following.include?(user)
    self.save
  end
  def follow_request_sent?(other_user)
    following_requests.exists?(receiver_id: other_user.id)
  end
  
end
