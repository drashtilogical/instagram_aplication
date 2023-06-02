class Photo < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :likes

  scope :public_photos, -> { where(public: true) }
end
