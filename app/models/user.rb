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

  def following?(other_user)
    followings.exists?(followed_user_id: other_user.id, status: 'accepted')
  end
end
