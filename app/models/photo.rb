# frozen_string_literal: true

# Represents a photo model
class Photo < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :likes
  has_many :comments

  scope :public_photos, -> { where(public: true) }
  def comments_count
    comments.count
  end
end
