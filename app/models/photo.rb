class Photo < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  scope :public_photos, -> { where(public: true) }
end
